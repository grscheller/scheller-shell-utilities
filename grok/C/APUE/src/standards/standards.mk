# Included makefile for chapter 2 - Unix Standards and Implementations

PATH_STDS := src/standards
PROGS_STDS := sysLimits sysNoLimits

PROGS_STDS_FULL := $(addprefix $(PATH_STDS)/,$(addsuffix $(EXT),$(PROGS_STDS)))
PROGS_STDS_INST := $(addprefix $(BIN)/,$(addsuffix $(EXT),$(PROGS_STDS)))

standards: $(PROGS_STDS_FULL)

$(PATH_STDS)/%$(EXT): $(PATH_STDS)/%.c $(APUE_H) $(LIBAPUE_A)
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ $< $(LDFLAGS)

$(PATH_STDS)/sysLimits$(EXT): $(PATH_STDS)/sysLimits.c \
                        $(PATH_STDS)/sysLimitsUtils.o \
                        $(APUE_H) $(LIBAPUE_A)
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ $< $(PATH_STDS)/sysLimitsUtils.o $(LDFLAGS)

$(PATH_STDS)/sysNoLimits$(EXT): $(PATH_STDS)/sysLimits.c \
                        $(PATH_STDS)/sysLimitsUtils.o \
                        $(APUE_H) $(LIBAPUE_A)
	$(CC) $(CFLAGS) -DNO_LIMITS $(CPPFLAGS) -o $@ $< $(PATH_STDS)/sysLimitsUtils.o $(LDFLAGS)

$(PATH_STDS)/sysLimits.c: $(PATH_STDS)/genSysLimits.awk \
	                      $(PATH_STDS)/confstr.sym \
	                      $(PATH_STDS)/sysconf.sym \
                          $(PATH_STDS)/pathconf.sym \
                          $(PATH_STDS)/feature.sym
	cd $(PATH_STDS); $(AWK) -f $(notdir $<) > $(notdir $@)

$(PATH_STDS)/%.o: $(PATH_STDS)/%.c $(APUE_H)
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -c $<

installstandards:
	@cp $(PROGS_STDS_FULL) $(BIN)

cleanstandards:
	rm -f $(PROGS_STDS_FULL) $(PATH_STDS)/sysLimits.c $(PATH_STDS)/*.o
	rm -f $(PROGS_STDS_INST)
