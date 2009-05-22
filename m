From: Andreas Dilger <adilger@sun.com>
Subject: Lustre basic tests script
Date: Fri, 22 May 2009 17:36:39 -0400
Message-ID: <20090522213639.GC13578@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39278 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006AbZEVVhQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 May 2009 17:37:16 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n4MLbDRS014108
	for <linux-ext4@vger.kernel.org>; Fri, 22 May 2009 14:37:15 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KK200A00EJ3BM00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 22 May 2009 14:37:13 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Below are included some of the tests from the Lustre "sanity.sh" script,
which tests filesystem behaviour in a variety of ways.  Some of them are
very simple and might concievably be removed, but are not necessarily bad.
I've removed the tests that depend on Lustre-specific behaviour.

It probably isn't useful to use this test script directly, since it
depends on a number of helper functions, but it is definitely useful
as a starting point for adding new tests to xfstests.

Unfortunately, a bunch of tests had to be removed since they depend on
Lustre's fault-injection code, but they would be useful for testing
generic filesystem behaviour (e.g. ENOMEM or ENOSPC handling).  There
is also a helper program we use "multiop" which is a toolbox program
that I could supply separately, if you want.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

============================================================================

TMP=${TMP:-/tmp}

[ -f $DIR/d52a/foo ] && chattr -a $DIR/d52a/foo
[ -f $DIR/d52b/foo ] && chattr -i $DIR/d52b/foo
rm -rf $DIR/[Rdfs][0-9]*

# $RUNAS_ID may get set incorrectly somewhere else
[ $UID -eq 0 -a $RUNAS_ID -eq 0 ] && error "\$RUNAS_ID set to 0, but \$UID is also 0!"


echo "preparing for tests involving mounts"
EXT2_DEV=${EXT2_DEV:-$TMP/SANITY.LOOP}
touch $EXT2_DEV
mke2fs -j -F $EXT2_DEV 8000 > /dev/null
echo # add a newline after mke2fs.

umask 077

test_0() {
	touch $DIR/$tfile
	$CHECKSTAT -t file $DIR/$tfile || error
	rm $DIR/$tfile
	$CHECKSTAT -a $DIR/$tfile || error
}
run_test 0 "touch .../$tfile ; rm .../$tfile"

test_0b() {
	chmod 0755 $DIR || error
	$CHECKSTAT -p 0755 $DIR || error
}
run_test 0b "chmod 0755 $DIR"

test_1a() {
	mkdir $DIR/d1
	mkdir $DIR/d1/d2
	mkdir $DIR/d1/d2 && error "we expect EEXIST, but not returned"
	$CHECKSTAT -t dir $DIR/d1/d2 || error
}
run_test 1a "mkdir .../d1; mkdir .../d1/d2"

test_1b() {
	rmdir $DIR/d1/d2
	rmdir $DIR/d1
	$CHECKSTAT -a $DIR/d1 || error
}
run_test 1b "rmdir .../d1/d2; rmdir .../d1"

test_2a() {
	mkdir $DIR/d2
	touch $DIR/d2/f
	$CHECKSTAT -t file $DIR/d2/f || error
}
run_test 2a "mkdir .../d2; touch .../d2/f"

test_2b() {
	rm -r $DIR/d2
	$CHECKSTAT -a $DIR/d2 || error
}
run_test 2b "rm -r .../d2; checkstat .../d2/f"

test_3a() {
	mkdir $DIR/d3
	$CHECKSTAT -t dir $DIR/d3 || error
}
run_test 3a "mkdir .../d3"

test_3b() {
	if [ ! -d $DIR/d3 ]; then
		mkdir $DIR/d3
	fi
	touch $DIR/d3/f
	$CHECKSTAT -t file $DIR/d3/f || error
}
run_test 3b "touch .../d3/f"

test_3c() {
	rm -r $DIR/d3
	$CHECKSTAT -a $DIR/d3 || error
}
run_test 3c "rm -r .../d3"

test_4a() {
	mkdir $DIR/d4
	$CHECKSTAT -t dir $DIR/d4 || error
}
run_test 4a "mkdir .../d4"

test_4b() {
	if [ ! -d $DIR/d4 ]; then
		mkdir $DIR/d4
	fi
	mkdir $DIR/d4/d2
	$CHECKSTAT -t dir $DIR/d4/d2 || error
}
run_test 4b "mkdir .../d4/d2"

test_5() {
	mkdir $DIR/d5
	mkdir $DIR/d5/d2
	chmod 0707 $DIR/d5/d2
	$CHECKSTAT -t dir -p 0707 $DIR/d5/d2 || error
}
run_test 5 "mkdir .../d5 .../d5/d2; chmod .../d5/d2"

test_6a() {
	touch $DIR/f6a
	chmod 0666 $DIR/f6a || error
	$CHECKSTAT -t file -p 0666 -u \#$UID $DIR/f6a || error
}
run_test 6a "touch .../f6a; chmod .../f6a"

test_6b() {
	[ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID = $UID -- skipping" && return
	if [ ! -f $DIR/f6a ]; then
		touch $DIR/f6a
		chmod 0666 $DIR/f6a
	fi
	$RUNAS chmod 0444 $DIR/f6a && error
	$CHECKSTAT -t file -p 0666 -u \#$UID $DIR/f6a || error
}
run_test 6b "$RUNAS chmod .../f6a (should return error)""

test_6c() {
	[ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID = $UID -- skipping" && return
	touch $DIR/f6c
	chown $RUNAS_ID $DIR/f6c || error
	$CHECKSTAT -t file -u \#$RUNAS_ID $DIR/f6c || error
}
run_test 6c "touch .../f6c; chown .../f6c"

test_6d() {
	[ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID = $UID -- skipping" && return
	if [ ! -f $DIR/f6c ]; then
		touch $DIR/f6c
		chown $RUNAS_ID $DIR/f6c
	fi
	$RUNAS chown $UID $DIR/f6c && error
	$CHECKSTAT -t file -u \#$RUNAS_ID $DIR/f6c || error
}
run_test 6d "$RUNAS chown .../f6c (should return error)""

test_6e() {
	[ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID = $UID -- skipping" && return
	touch $DIR/f6e
	chgrp $RUNAS_ID $DIR/f6e || error
	$CHECKSTAT -t file -u \#$UID -g \#$RUNAS_ID $DIR/f6e || error
}
run_test 6e "touch .../f6e; chgrp .../f6e"

test_6f() {
	[ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID = $UID -- skipping" && return
	if [ ! -f $DIR/f6e ]; then
		touch $DIR/f6e
		chgrp $RUNAS_ID $DIR/f6e
	fi
	$RUNAS chgrp $UID $DIR/f6e && error
	$CHECKSTAT -t file -u \#$UID -g \#$RUNAS_ID $DIR/f6e || error
}
run_test 6f "$RUNAS chgrp .../f6e (should return error)""

test_6g() {
	[ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID = $UID -- skipping" && return
        mkdir $DIR/d6g || error
        chmod 777 $DIR/d6g || error
        $RUNAS mkdir $DIR/d6g/d || error
        chmod g+s $DIR/d6g/d || error
        mkdir $DIR/d6g/d/subdir
	$CHECKSTAT -g \#$RUNAS_ID $DIR/d6g/d/subdir || error
}
run_test 6g "Is new dir in sgid dir inheriting group?"

test_6h() { # bug 7331
	[ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID = $UID -- skipping" && return
	touch $DIR/f6h || error "touch failed"
	chown $RUNAS_ID:$RUNAS_ID $DIR/f6h || error "initial chown failed"
	$RUNAS -G$RUNAS_ID chown $RUNAS_ID:0 $DIR/f6h && error "chown worked"
	$CHECKSTAT -t file -u \#$RUNAS_ID -g \#$RUNAS_ID $DIR/f6h || error
}
run_test 6h "$RUNAS chown RUNAS_ID.0 .../f6h (should return error)"

test_7a() {
	mkdir $DIR/d7
	$MCREATE $DIR/d7/f
	chmod 0666 $DIR/d7/f
	$CHECKSTAT -t file -p 0666 $DIR/d7/f || error
}
run_test 7a "mkdir .../d7; mcreate .../d7/f; chmod .../d7/f""

test_7b() {
	if [ ! -d $DIR/d7 ]; then
		mkdir $DIR/d7
	fi
	$MCREATE $DIR/d7/f2
	echo -n foo > $DIR/d7/f2
	[ "`cat $DIR/d7/f2`"" "foo" ] || error
	$CHECKSTAT -t file -s 3 $DIR/d7/f2 || error
}
run_test 7b "mkdir .../d7; mcreate d7/f2; echo foo > d7/f2"

test_8() {
	mkdir $DIR/d8
	touch $DIR/d8/f
	chmod 0666 $DIR/d8/f
	$CHECKSTAT -t file -p 0666 $DIR/d8/f || error
}
run_test 8 "mkdir .../d8; touch .../d8/f; chmod .../d8/f"

test_9() {
	mkdir $DIR/d9
	mkdir $DIR/d9/d2
	mkdir $DIR/d9/d2/d3
	$CHECKSTAT -t dir $DIR/d9/d2/d3 || error
}
run_test 9 "mkdir .../d9 .../d9/d2 .../d9/d2/d3"

test_10() {
	mkdir $DIR/d10
	mkdir $DIR/d10/d2
	touch $DIR/d10/d2/f
	$CHECKSTAT -t file $DIR/d10/d2/f || error
}
run_test 10 "mkdir .../d10 .../d10/d2; touch .../d10/d2/f"

test_11() {
	mkdir $DIR/d11
	mkdir $DIR/d11/d2
	chmod 0666 $DIR/d11/d2
	chmod 0705 $DIR/d11/d2
	$CHECKSTAT -t dir -p 0705 $DIR/d11/d2 || error
}
run_test 11 "mkdir .../d11 d11/d2; chmod .../d11/d2"

test_12() {
	mkdir $DIR/d12
	touch $DIR/d12/f
	chmod 0666 $DIR/d12/f
	chmod 0654 $DIR/d12/f
	$CHECKSTAT -t file -p 0654 $DIR/d12/f || error
}
run_test 12 "touch .../d12/f; chmod .../d12/f .../d12/f"

test_13() {
	mkdir $DIR/d13
	dd if=/dev/zero of=$DIR/d13/f count=10
	>  $DIR/d13/f
	$CHECKSTAT -t file -s 0 $DIR/d13/f || error
}
run_test 13 "creat .../d13/f; dd .../d13/f; > .../d13/f"

test_14() {
	mkdir $DIR/d14
	touch $DIR/d14/f
	rm $DIR/d14/f
	$CHECKSTAT -a $DIR/d14/f || error
}
run_test 14 "touch .../d14/f; rm .../d14/f; rm .../d14/f"

test_15() {
	mkdir $DIR/d15
	touch $DIR/d15/f
	mv $DIR/d15/f $DIR/d15/f2
	$CHECKSTAT -t file $DIR/d15/f2 || error
}
run_test 15 "touch .../d15/f; mv .../d15/f .../d15/f2"

test_16() {
	mkdir $DIR/d16
	touch $DIR/d16/f
	rm -rf $DIR/d16/f
	$CHECKSTAT -a $DIR/d16/f || error
}
run_test 16 "touch .../d16/f; rm -rf .../d16/f"

test_17a() {
	mkdir -p $DIR/d17
	touch $DIR/d17/f
	ln -s $DIR/d17/f $DIR/d17/l-exist
	ls -l $DIR/d17
	$CHECKSTAT -l $DIR/d17/f $DIR/d17/l-exist || error
	$CHECKSTAT -f -t f $DIR/d17/l-exist || error
	rm -f $DIR/d17/l-exist
	$CHECKSTAT -a $DIR/d17/l-exist || error
}
run_test 17a "symlinks: create, remove (real)"

test_17b() {
	mkdir -p $DIR/d17
	ln -s no-such-file $DIR/d17/l-dangle
	ls -l $DIR/d17
	$CHECKSTAT -l no-such-file $DIR/d17/l-dangle || error
	$CHECKSTAT -fa $DIR/d17/l-dangle || error
	rm -f $DIR/d17/l-dangle
	$CHECKSTAT -a $DIR/d17/l-dangle || error
}
run_test 17b "symlinks: create, remove (dangling)"

test_17c() { # bug 3440 - don't save failed open RPC for replay
	mkdir -p $DIR/d17
	ln -s foo $DIR/d17/f17c
	cat $DIR/d17/f17c && error "opened non-existent symlink" || true
}
run_test 17c "symlinks: open dangling (should return error)""

test_17d() {
	mkdir -p $DIR/d17
	ln -s foo $DIR/d17/f17d
	touch $DIR/d17/f17d || error "creating to new symlink"
}
run_test 17d "symlinks: create dangling"

test_17e() {
	mkdir -p $DIR/$tdir
	local foo=$DIR/$tdir/$tfile
	ln -s $foo $foo || error "create symlink failed"
	ls -l $foo || error "ls -l failed"
	ls $foo && error "ls not failed" || true
}
run_test 17e "symlinks: create recursive symlink (should return error)""

test_17f() {
	mkdir -p $DIR/d17f
	ln -s 1234567890/2234567890/3234567890/4234567890 $DIR/d17f/111
	ln -s 1234567890/2234567890/3234567890/4234567890/5234567890/6234567890 $DIR/d17f/222
	ln -s 1234567890/2234567890/3234567890/4234567890/5234567890/6234567890/7234567890/8234567890 $DIR/d17f/333
	ln -s 1234567890/2234567890/3234567890/4234567890/5234567890/6234567890/7234567890/8234567890/9234567890/a234567890/b234567890 $DIR/d17f/444
	ln -s 1234567890/2234567890/3234567890/4234567890/5234567890/6234567890/7234567890/8234567890/9234567890/a234567890/b234567890/c234567890/d234567890/f234567890 $DIR/d17f/555
	ln -s 1234567890/2234567890/3234567890/4234567890/5234567890/6234567890/7234567890/8234567890/9234567890/a234567890/b234567890/c234567890/d234567890/f234567890/aaaaaaaaaa/bbbbbbbbbb/cccccccccc/dddddddddd/eeeeeeeeee/ffffffffff/ $DIR/d17f/666
	ls -l  $DIR/d17f
}
run_test 17f "symlinks: long and very long symlink name"

test_17g() {
        mkdir -p $DIR/$tdir
        LONGSYMLINK="$(dd if=/dev/zero bs=4095 count=1 | tr '\0' 'x')"
        ln -s $LONGSYMLINK $DIR/$tdir/$tfile
        ls -l $DIR/$tdir
}
run_test 17g "symlinks: really long symlink name"

test_17h() { #bug 17378
        mkdir -p $DIR/$tdir
        $SETSTRIPE $DIR/$tdir -c -1
#define OBD_FAIL_MDS_LOV_PREP_CREATE 0x141
        do_facet mds lctl set_param fail_loc=0x80000141
        touch $DIR/$tdir/$tfile || true
}
run_test 17h "create objects: lov_free_memmd() doesn't lbug"

test_18() {
	touch $DIR/f
	ls $DIR || error
}
run_test 18 "touch .../f ; ls ..."

test_19a() {
	touch $DIR/f19
	ls -l $DIR
	rm $DIR/f19
	$CHECKSTAT -a $DIR/f19 || error
}
run_test 19a "touch .../f19 ; ls -l ... ; rm .../f19"

test_19b() {
	ls -l $DIR/f19 && error || true
}
run_test 19b "ls -l .../f19 (should return error)"

test_19c() {
	[ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID = $UID -- skipping" && return
	$RUNAS touch $DIR/f19 && error || true
}
run_test 19c "$RUNAS touch .../f19 (should return error)""

test_19d() {
	cat $DIR/f19 && error || true
}
run_test 19d "cat .../f19 (should return error)"

test_20() {
	touch $DIR/f
	rm $DIR/f
	log "1 done"
	touch $DIR/f
	rm $DIR/f
	log "2 done"
	touch $DIR/f
	rm $DIR/f
	log "3 done"
	$CHECKSTAT -a $DIR/f || error
}
run_test 20 "touch .../f ; ls -l ..."

test_21() {
	mkdir $DIR/d21
	[ -f $DIR/d21/dangle ] && rm -f $DIR/d21/dangle
	ln -s dangle $DIR/d21/link
	echo foo >> $DIR/d21/link
	cat $DIR/d21/dangle
	$CHECKSTAT -t link $DIR/d21/link || error
	$CHECKSTAT -f -t file $DIR/d21/link || error
}
run_test 21 "write to dangling link"

test_22() {
	WDIR=$DIR/$tdir
	mkdir -p $WDIR
	chown $RUNAS_ID $WDIR
	(cd $WDIR || error "cd $WDIR failed";
	$RUNAS tar cf - /etc/hosts /etc/sysconfig/network | \
	$RUNAS tar xf -)
	ls -lR $WDIR/etc || error "ls -lR $WDIR/etc failed"
	$CHECKSTAT -t dir $WDIR/etc || error "checkstat -t dir failed"
	$CHECKSTAT -u \#$RUNAS_ID $WDIR/etc || error "checkstat -u failed"
}
run_test 22 "unpack tar archive as non-root user"

test_23() {
	mkdir -p $DIR/$tdir
	local file=$DIR/$tdir/$tfile

	openfile -f O_CREAT:O_EXCL $file || error "$file create failed"
	openfile -f O_CREAT:O_EXCL $file &&
		error "$file recreate succeeded" || true
}
run_test 23 "O_CREAT|O_EXCL in subdir"

test_24a() {
	echo '== rename sanity"
	echo '-- same directory rename'
	mkdir $DIR/R1
	touch $DIR/R1/f
	mv $DIR/R1/f $DIR/R1/g
	$CHECKSTAT -t file $DIR/R1/g || error
}
run_test 24a "touch .../R1/f; rename .../R1/f .../R1/g"

test_24b() {
	mkdir $DIR/R2
	touch $DIR/R2/{f,g}
	mv $DIR/R2/f $DIR/R2/g
	$CHECKSTAT -a $DIR/R2/f || error
	$CHECKSTAT -t file $DIR/R2/g || error
}
run_test 24b "touch .../R2/{f,g}; rename .../R2/f .../R2/g"

test_24c() {
	mkdir $DIR/R3
	mkdir $DIR/R3/f
	mv $DIR/R3/f $DIR/R3/g
	$CHECKSTAT -a $DIR/R3/f || error
	$CHECKSTAT -t dir $DIR/R3/g || error
}
run_test 24c "mkdir .../R3/f; rename .../R3/f .../R3/g"

test_24d() {
	mkdir $DIR/R4
	mkdir $DIR/R4/{f,g}
	mrename $DIR/R4/f $DIR/R4/g
	$CHECKSTAT -a $DIR/R4/f || error
	$CHECKSTAT -t dir $DIR/R4/g || error
}
run_test 24d "mkdir .../R4/{f,g}; rename .../R4/f .../R4/g"

test_24e() {
	echo '-- cross directory renames --'
	mkdir $DIR/R5{a,b}
	touch $DIR/R5a/f
	mv $DIR/R5a/f $DIR/R5b/g
	$CHECKSTAT -a $DIR/R5a/f || error
	$CHECKSTAT -t file $DIR/R5b/g || error
}
run_test 24e "touch .../R5a/f; rename .../R5a/f .../R5b/g"

test_24f() {
	mkdir $DIR/R6{a,b}
	touch $DIR/R6a/f $DIR/R6b/g
	mv $DIR/R6a/f $DIR/R6b/g
	$CHECKSTAT -a $DIR/R6a/f || error
	$CHECKSTAT -t file $DIR/R6b/g || error
}
run_test 24f "touch .../R6a/f R6b/g; mv .../R6a/f .../R6b/g""

test_24g() {
	mkdir $DIR/R7{a,b}
	mkdir $DIR/R7a/d
	mv $DIR/R7a/d $DIR/R7b/e
	$CHECKSTAT -a $DIR/R7a/d || error
	$CHECKSTAT -t dir $DIR/R7b/e || error
}
run_test 24g "mkdir .../R7{a,b}/d; mv .../R7a/d .../R7b/e"

test_24h() {
	mkdir $DIR/R8{a,b}
	mkdir $DIR/R8a/d $DIR/R8b/e
	mrename $DIR/R8a/d $DIR/R8b/e
	$CHECKSTAT -a $DIR/R8a/d || error
	$CHECKSTAT -t dir $DIR/R8b/e || error
}
run_test 24h "mkdir .../R8{a,b}/{d,e}; rename .../R8a/d .../R8b/e"

test_24i() {
	echo "-- rename error cases"
	mkdir $DIR/R9
	mkdir $DIR/R9/a
	touch $DIR/R9/f
	mrename $DIR/R9/f $DIR/R9/a
	$CHECKSTAT -t file $DIR/R9/f || error
	$CHECKSTAT -t dir  $DIR/R9/a || error
	$CHECKSTAT -a $DIR/R9/a/f || error
}
run_test 24i "rename file to dir error: touch f ; mkdir a ; rename f a"

test_24j() {
	mkdir $DIR/R10
	mrename $DIR/R10/f $DIR/R10/g
	$CHECKSTAT -t dir $DIR/R10 || error
	$CHECKSTAT -a $DIR/R10/f || error
	$CHECKSTAT -a $DIR/R10/g || error
}
run_test 24j "source does not exist"

test_24k() {
	mkdir $DIR/R11a $DIR/R11a/d
	touch $DIR/R11a/f
	mv $DIR/R11a/f $DIR/R11a/d
        $CHECKSTAT -a $DIR/R11a/f || error
        $CHECKSTAT -t file $DIR/R11a/d/f || error
}
run_test 24k "touch .../R11a/f; mv .../R11a/f .../R11a/d"

# bug 2429 - rename foo foo foo creates invalid file
test_24l() {
	f="$DIR/f24l"
	multiop $f OcNs || error
}
run_test 24l "Renaming a file to itself"

test_24m() {
	f="$DIR/f24m"
	multiop $f OcLN ${f}2 ${f}2 || error "link ${f}2 ${f}2 failed"
	# on ext3 this does not remove either the source or target files
	# though the "expected" operation would be to remove the source
	$CHECKSTAT -t file ${f} || error "${f} missing"
	$CHECKSTAT -t file ${f}2 || error "${f}2 missing"
}
run_test 24m "Renaming a file to a hard link to itself"

test_24n() {
    f="$DIR/f24n"
    # this stats the old file after it was renamed, so it should fail
    touch ${f}
    $CHECKSTAT ${f}
    mv ${f} ${f}.rename
    $CHECKSTAT ${f}.rename
    $CHECKSTAT -a ${f}
}
run_test 24n "Statting the old file after renaming (Posix rename 2)"

test_24o() {
	check_kernel_version 37 || return 0
	mkdir -p $DIR/d24o
	rename_many -s random -v -n 10 $DIR/d24o
}
run_test 24o "rename of files during htree split"

test_24p() {
	mkdir $DIR/R12{a,b}
	DIRINO=`ls -lid $DIR/R12a | awk '{ print $1 }'`
	mrename $DIR/R12a $DIR/R12b
	$CHECKSTAT -a $DIR/R12a || error
	$CHECKSTAT -t dir $DIR/R12b || error
	DIRINO2=`ls -lid $DIR/R12b | awk '{ print $1 }'`
	[ "$DIRINO"" "$DIRINO2" ] || error "R12a $DIRINO != R12b $DIRINO2"
}
run_test 24p "mkdir .../R12{a,b}; rename .../R12a .../R12b"

test_24q() {
	mkdir $DIR/R13{a,b}
	DIRINO=`ls -lid $DIR/R13a | awk '{ print $1 }'`
	multiop_bg_pause $DIR/R13b D_c || return 1
	MULTIPID=$!

	mrename $DIR/R13a $DIR/R13b
	$CHECKSTAT -a $DIR/R13a || error
	$CHECKSTAT -t dir $DIR/R13b || error
	DIRINO2=`ls -lid $DIR/R13b | awk '{ print $1 }'`
	[ "$DIRINO"" "$DIRINO2" ] || error "R13a $DIRINO != R13b $DIRINO2"
	kill -USR1 $MULTIPID
	wait $MULTIPID || error "multiop close failed"
}
run_test 24q "mkdir .../R13{a,b}; open R13b rename R13a R13b""

test_24r() { #bug 3789
	mkdir $DIR/R14a $DIR/R14a/b
	mrename $DIR/R14a $DIR/R14a/b && error "rename to subdir worked!"
	$CHECKSTAT -t dir $DIR/R14a || error "$DIR/R14a missing"
	$CHECKSTAT -t dir $DIR/R14a/b || error "$DIR/R14a/b missing"
}
run_test 24r "mkdir .../R14a/b; rename .../R14a .../R14a/b"

test_24s() {
	mkdir $DIR/R15a $DIR/R15a/b $DIR/R15a/b/c
	mrename $DIR/R15a $DIR/R15a/b/c && error "rename to sub-subdir worked!"
	$CHECKSTAT -t dir $DIR/R15a || error "$DIR/R15a missing"
	$CHECKSTAT -t dir $DIR/R15a/b/c || error "$DIR/R15a/b/c missing"
}
run_test 24s "mkdir .../R15a/b/c; rename .../R15a .../R15a/b/c""
test_24t() {
	mkdir $DIR/R16a $DIR/R16a/b $DIR/R16a/b/c
	mrename $DIR/R16a/b/c $DIR/R16a && error "rename to sub-subdir worked!"
	$CHECKSTAT -t dir $DIR/R16a || error "$DIR/R16a missing"
	$CHECKSTAT -t dir $DIR/R16a/b/c || error "$DIR/R16a/b/c missing"
}
run_test 24t "mkdir .../R16a/b/c; rename .../R16a/b/c .../R16a""

test_24u() { # bug12192
        multiop $DIR/$tfile C2w$((2048 * 1024))c || error
        $CHECKSTAT -s $((2048 * 1024)) $DIR/$tfile || error "wrong file size"
}
run_test 24u "create stripe file"

test_25a() {
	echo '== symlink sanity"

	mkdir $DIR/d25
	ln -s d25 $DIR/s25
	touch $DIR/s25/foo || error
}
run_test 25a "create file in symlinked directory"

test_25b() {
	[ ! -d $DIR/d25 ] && test_25a
	$CHECKSTAT -t file $DIR/s25/foo || error
}
run_test 25b "lookup file in symlinked directory""

test_26a() {
	mkdir $DIR/d26
	mkdir $DIR/d26/d26-2
	ln -s d26/d26-2 $DIR/s26
	touch $DIR/s26/foo || error
}
run_test 26a "multiple component symlink""

test_26b() {
	mkdir -p $DIR/d26b/d26-2
	ln -s d26b/d26-2/foo $DIR/s26-2
	touch $DIR/s26-2 || error
}
run_test 26b "multiple component symlink at end of lookup""

test_26c() {
	mkdir $DIR/d26.2
	touch $DIR/d26.2/foo
	ln -s d26.2 $DIR/s26.2-1
	ln -s s26.2-1 $DIR/s26.2-2
	ln -s s26.2-2 $DIR/s26.2-3
	chmod 0666 $DIR/s26.2-3/foo
}
run_test 26c "chain of symlinks""

# recursive symlinks (bug 439)
test_26d() {
	ln -s d26-3/foo $DIR/d26-3
}
run_test 26d "create multiple component recursive symlink""

test_26e() {
	[ ! -h $DIR/d26-3 ] && test_26d
	rm $DIR/d26-3
}
run_test 26e "unlink multiple component recursive symlink""

# recursive symlinks (bug 7022)
test_26f() {
	mkdir -p $DIR/$tdir
	mkdir $DIR/$tdir/$tfile        || error "mkdir $DIR/$tdir/$tfile failed"
	cd $DIR/$tdir/$tfile           || error "cd $DIR/$tdir/$tfile failed"
	mkdir -p lndir/bar1      || error "mkdir lndir/bar1 failed"
	mkdir $tfile             || error "mkdir $tfile failed"
	cd $tfile                || error "cd $tfile failed"
	ln -s .. dotdot          || error "ln dotdot failed"
	ln -s dotdot/lndir lndir || error "ln lndir failed"
	cd $DIR/$tdir                 || error "cd $DIR/$tdir failed"
	output=`ls $tfile/$tfile/lndir/bar1`
	[ "$output"" bar1 ] && error "unexpected output"
	rm -r $tfile             || error "rm $tfile failed"
	$CHECKSTAT -a $DIR/$tfile || error "$tfile not gone"
}
run_test 26f "rm -r of a directory which has recursive symlink""

# createtest also checks that device nodes are created and
# then visible correctly (#2091)
test_28() { # bug 2091
	mkdir $DIR/d28
	$CREATETEST $DIR/d28/ct || error
}
run_test 28 "create/mknod/mkdir with bad file types""

test_30() {
	cp `which ls` $DIR || cp /bin/ls $DIR
	$DIR/ls /
	rm $DIR/ls
}
run_test 30 "run binary from Lustre (execve)""

test_31a() {
	$OPENUNLINK $DIR/f31 $DIR/f31 || error
	$CHECKSTAT -a $DIR/f31 || error
}
run_test 31a "open-unlink file""

test_31b() {
	touch $DIR/f31 || error
	ln $DIR/f31 $DIR/f31b || error
	multiop $DIR/f31b Ouc || error
	$CHECKSTAT -t file $DIR/f31 || error
}
run_test 31b "unlink file with multiple links while open""

test_31c() {
	touch $DIR/f31 || error
	ln $DIR/f31 $DIR/f31c || error
	multiop_bg_pause $DIR/f31 O_uc || return 1
	MULTIPID=$!
	multiop $DIR/f31c Ouc
	kill -USR1 $MULTIPID
	wait $MULTIPID
}
run_test 31c "open-unlink file with multiple links""

test_31d() {
	opendirunlink $DIR/d31d $DIR/d31d || error
	$CHECKSTAT -a $DIR/d31d || error
}
run_test 31d "remove of open directory""

test_31e() { # bug 2904
	check_kernel_version 34 || return 0
	openfilleddirunlink $DIR/d31e || error
}
run_test 31e "remove of open non-empty directory""

test_31f() { # bug 4554
	set -vx
	mkdir $DIR/d31f
	$SETSTRIPE $DIR/d31f -s 1048576 -c 1
	cp /etc/hosts $DIR/d31f
	ls -l $DIR/d31f
	multiop_bg_pause $DIR/d31f D_c || return 1
	MULTIPID=$!

	rm -rv $DIR/d31f || error "first of $DIR/d31f"
	mkdir $DIR/d31f
	$SETSTRIPE $DIR/d31f -s 1048576 -c 1
	cp /etc/hosts $DIR/d31f
	ls -l $DIR/d31f
	$DIR/d31f/hosts
	multiop_bg_pause $DIR/d31f D_c || return 1
	MULTIPID2=$!

	kill -USR1 $MULTIPID || error "first opendir $MULTIPID not running"
	wait $MULTIPID || error "first opendir $MULTIPID failed"

	sleep 6

	kill -USR1 $MULTIPID2 || error "second opendir $MULTIPID not running"
	wait $MULTIPID2 || error "second opendir $MULTIPID2 failed"
	set +vx
}
run_test 31f "remove of open directory with open-unlink file""

test_31g() {
        echo "-- cross directory link --"
        mkdir $DIR/d31g{a,b}
        touch $DIR/d31ga/f
        ln $DIR/d31ga/f $DIR/d31gb/g
        $CHECKSTAT -t file $DIR/d31ga/f || error "source"
        [ `stat -c%h $DIR/d31ga/f`" '2' ] || error "source nlink"
        $CHECKSTAT -t file $DIR/d31gb/g || error "target"
        [ `stat -c%h $DIR/d31gb/g`" '2' ] || error "target nlink"
}
run_test 31g "cross directory link==============="

test_31h() {
        echo "-- cross directory link --"
        mkdir $DIR/d31h
        mkdir $DIR/d31h/dir
        touch $DIR/d31h/f
        ln $DIR/d31h/f $DIR/d31h/dir/g
        $CHECKSTAT -t file $DIR/d31h/f || error "source"
        [ `stat -c%h $DIR/d31h/f`" '2' ] || error "source nlink"
        $CHECKSTAT -t file $DIR/d31h/dir/g || error "target"
        [ `stat -c%h $DIR/d31h/dir/g`" '2' ] || error "target nlink"
}
run_test 31h "cross directory link under child==============="

test_31i() {
        echo "-- cross directory link --"
        mkdir $DIR/d31i
        mkdir $DIR/d31i/dir
        touch $DIR/d31i/dir/f
        ln $DIR/d31i/dir/f $DIR/d31i/g
        $CHECKSTAT -t file $DIR/d31i/dir/f || error "source"
        [ `stat -c%h $DIR/d31i/dir/f`" '2' ] || error "source nlink"
        $CHECKSTAT -t file $DIR/d31i/g || error "target"
        [ `stat -c%h $DIR/d31i/g`" '2' ] || error "target nlink"
}
run_test 31i "cross directory link under parent==============="


test_31j() {
        mkdir $DIR/d31j
        mkdir $DIR/d31j/dir1
        ln $DIR/d31j/dir1 $DIR/d31j/dir2 && error "ln for dir"
        link $DIR/d31j/dir1 $DIR/d31j/dir3 && error "link for dir"
        mlink $DIR/d31j/dir1 $DIR/d31j/dir4 && error "mlink for dir"
        mlink $DIR/d31j/dir1 $DIR/d31j/dir1 && error "mlink to the same dir"
	return 0
}
run_test 31j "link for directory==============="


test_31k() {
        mkdir $DIR/d31k
        touch $DIR/d31k/s
        touch $DIR/d31k/exist
        mlink $DIR/d31k/s $DIR/d31k/t || error "mlink"
        mlink $DIR/d31k/s $DIR/d31k/exist && error "mlink to exist file"
        mlink $DIR/d31k/s $DIR/d31k/s && error "mlink to the same file"
        mlink $DIR/d31k/s $DIR/d31k && error "mlink to parent dir"
        mlink $DIR/d31k $DIR/d31k/s && error "mlink parent dir to target"
        mlink $DIR/d31k/not-exist $DIR/d31k/foo && error "mlink non-existing to new"
        mlink $DIR/d31k/not-exist $DIR/d31k/s && error "mlink non-existing to exist"
	return 0
}
run_test 31k "link to file: the same, non-existing, dir==============="

test_31m() {
        mkdir $DIR/d31m
        touch $DIR/d31m/s
        mkdir $DIR/d31m2
        touch $DIR/d31m2/exist
        mlink $DIR/d31m/s $DIR/d31m2/t || error "mlink"
        mlink $DIR/d31m/s $DIR/d31m2/exist && error "mlink to exist file"
        mlink $DIR/d31m/s $DIR/d31m2 && error "mlink to parent dir"
        mlink $DIR/d31m2 $DIR/d31m/s && error "mlink parent dir to target"
        mlink $DIR/d31m/not-exist $DIR/d31m2/foo && error "mlink non-existing to new"
        mlink $DIR/d31m/not-exist $DIR/d31m2/s && error "mlink non-existing to exist"
	return 0
}
run_test 31m "link to file: the same, non-existing, dir==============="

test_32a() {
	echo "== more mountpoints and symlinks""
	[ -e $DIR/d32a ] && rm -fr $DIR/d32a
	mkdir -p $DIR/d32a/ext2-mountpoint
	mount -t ext2 -o loop $EXT2_DEV $DIR/d32a/ext2-mountpoint || error
	$CHECKSTAT -t dir $DIR/d32a/ext2-mountpoint/.. || error
	$UMOUNT $DIR/d32a/ext2-mountpoint || error
}
run_test 32a "stat d32a/ext2-mountpoint/..""

test_32b() {
	[ -e $DIR/d32b ] && rm -fr $DIR/d32b
	mkdir -p $DIR/d32b/ext2-mountpoint
	mount -t ext2 -o loop $EXT2_DEV $DIR/d32b/ext2-mountpoint || error
	ls -al $DIR/d32b/ext2-mountpoint/.. || error
	$UMOUNT $DIR/d32b/ext2-mountpoint || error
}
run_test 32b "open d32b/ext2-mountpoint/..""

test_32c() {
	[ -e $DIR/d32c ] && rm -fr $DIR/d32c
	mkdir -p $DIR/d32c/ext2-mountpoint
	mount -t ext2 -o loop $EXT2_DEV $DIR/d32c/ext2-mountpoint || error
	mkdir -p $DIR/d32c/d2/test_dir
	$CHECKSTAT -t dir $DIR/d32c/ext2-mountpoint/../d2/test_dir || error
	$UMOUNT $DIR/d32c/ext2-mountpoint || error
}
run_test 32c "stat d32c/ext2-mountpoint/../d2/test_dir""

test_32d() {
	[ -e $DIR/d32d ] && rm -fr $DIR/d32d
	mkdir -p $DIR/d32d/ext2-mountpoint
	mount -t ext2 -o loop $EXT2_DEV $DIR/d32d/ext2-mountpoint || error
	mkdir -p $DIR/d32d/d2/test_dir
	ls -al $DIR/d32d/ext2-mountpoint/../d2/test_dir || error
	$UMOUNT $DIR/d32d/ext2-mountpoint || error
}
run_test 32d "open d32d/ext2-mountpoint/../d2/test_dir""

test_32e() {
	[ -e $DIR/d32e ] && rm -fr $DIR/d32e
	mkdir -p $DIR/d32e/tmp
	TMP_DIR=$DIR/d32e/tmp
	ln -s $DIR/d32e $TMP_DIR/symlink11
	ln -s $TMP_DIR/symlink11 $TMP_DIR/../symlink01
	$CHECKSTAT -t link $DIR/d32e/tmp/symlink11 || error
	$CHECKSTAT -t link $DIR/d32e/symlink01 || error
}
run_test 32e "stat d32e/symlink->tmp/symlink->lustre-subdir""

test_32f() {
	[ -e $DIR/d32f ] && rm -fr $DIR/d32f
	mkdir -p $DIR/d32f/tmp
	TMP_DIR=$DIR/d32f/tmp
	ln -s $DIR/d32f $TMP_DIR/symlink11
	ln -s $TMP_DIR/symlink11 $TMP_DIR/../symlink01
	ls $DIR/d32f/tmp/symlink11  || error
	ls $DIR/d32f/symlink01 || error
}
run_test 32f "open d32f/symlink->tmp/symlink->lustre-subdir""

test_32g() {
	TMP_DIR=$DIR/$tdir/tmp
	mkdir -p $TMP_DIR $DIR/${tdir}2
	ln -s $DIR/${tdir}2 $TMP_DIR/symlink12
	ln -s $TMP_DIR/symlink12 $TMP_DIR/../symlink02
	$CHECKSTAT -t link $TMP_DIR/symlink12 || error
	$CHECKSTAT -t link $DIR/$tdir/symlink02 || error
	$CHECKSTAT -t dir -f $TMP_DIR/symlink12 || error
	$CHECKSTAT -t dir -f $DIR/$tdir/symlink02 || error
}
run_test 32g "stat d32g/symlink->tmp/symlink->lustre-subdir/${tdir}2"

test_32h() {
	rm -fr $DIR/$tdir $DIR/${tdir}2
	TMP_DIR=$DIR/$tdir/tmp
	mkdir -p $TMP_DIR $DIR/${tdir}2
	ln -s $DIR/${tdir}2 $TMP_DIR/symlink12
	ln -s $TMP_DIR/symlink12 $TMP_DIR/../symlink02
	ls $TMP_DIR/symlink12 || error
	ls $DIR/$tdir/symlink02  || error
}
run_test 32h "open d32h/symlink->tmp/symlink->lustre-subdir/${tdir}2"

test_32i() {
	[ -e $DIR/d32i ] && rm -fr $DIR/d32i
	mkdir -p $DIR/d32i/ext2-mountpoint
	mount -t ext2 -o loop $EXT2_DEV $DIR/d32i/ext2-mountpoint || error
	touch $DIR/d32i/test_file
	$CHECKSTAT -t file $DIR/d32i/ext2-mountpoint/../test_file || error
	$UMOUNT $DIR/d32i/ext2-mountpoint || error
}
run_test 32i "stat d32i/ext2-mountpoint/../test_file""

test_32j() {
	[ -e $DIR/d32j ] && rm -fr $DIR/d32j
	mkdir -p $DIR/d32j/ext2-mountpoint
	mount -t ext2 -o loop $EXT2_DEV $DIR/d32j/ext2-mountpoint || error
	touch $DIR/d32j/test_file
	cat $DIR/d32j/ext2-mountpoint/../test_file || error
	$UMOUNT $DIR/d32j/ext2-mountpoint || error
}
run_test 32j "open d32j/ext2-mountpoint/../test_file""

test_32k() {
	rm -fr $DIR/d32k
	mkdir -p $DIR/d32k/ext2-mountpoint
	mount -t ext2 -o loop $EXT2_DEV $DIR/d32k/ext2-mountpoint
	mkdir -p $DIR/d32k/d2
	touch $DIR/d32k/d2/test_file || error
	$CHECKSTAT -t file $DIR/d32k/ext2-mountpoint/../d2/test_file || error
	$UMOUNT $DIR/d32k/ext2-mountpoint || error
}
run_test 32k "stat d32k/ext2-mountpoint/../d2/test_file""

test_32l() {
	rm -fr $DIR/d32l
	mkdir -p $DIR/d32l/ext2-mountpoint
	mount -t ext2 -o loop $EXT2_DEV $DIR/d32l/ext2-mountpoint || error
	mkdir -p $DIR/d32l/d2
	touch $DIR/d32l/d2/test_file
	cat  $DIR/d32l/ext2-mountpoint/../d2/test_file || error
	$UMOUNT $DIR/d32l/ext2-mountpoint || error
}
run_test 32l "open d32l/ext2-mountpoint/../d2/test_file""

test_32m() {
	rm -fr $DIR/d32m
	mkdir -p $DIR/d32m/tmp
	TMP_DIR=$DIR/d32m/tmp
	ln -s $DIR $TMP_DIR/symlink11
	ln -s $TMP_DIR/symlink11 $TMP_DIR/../symlink01
	$CHECKSTAT -t link $DIR/d32m/tmp/symlink11 || error
	$CHECKSTAT -t link $DIR/d32m/symlink01 || error
}
run_test 32m "stat d32m/symlink->tmp/symlink->lustre-root""

test_32n() {
	rm -fr $DIR/d32n
	mkdir -p $DIR/d32n/tmp
	TMP_DIR=$DIR/d32n/tmp
	ln -s $DIR $TMP_DIR/symlink11
	ln -s $TMP_DIR/symlink11 $TMP_DIR/../symlink01
	ls -l $DIR/d32n/tmp/symlink11  || error
	ls -l $DIR/d32n/symlink01 || error
}
run_test 32n "open d32n/symlink->tmp/symlink->lustre-root""

test_32o() {
	rm -fr $DIR/d32o $DIR/$tfile
	touch $DIR/$tfile
	mkdir -p $DIR/d32o/tmp
	TMP_DIR=$DIR/d32o/tmp
	ln -s $DIR/$tfile $TMP_DIR/symlink12
	ln -s $TMP_DIR/symlink12 $TMP_DIR/../symlink02
	$CHECKSTAT -t link $DIR/d32o/tmp/symlink12 || error
	$CHECKSTAT -t link $DIR/d32o/symlink02 || error
	$CHECKSTAT -t file -f $DIR/d32o/tmp/symlink12 || error
	$CHECKSTAT -t file -f $DIR/d32o/symlink02 || error
}
run_test 32o "stat d32o/symlink->tmp/symlink->lustre-root/$tfile"

test_32p() {
    log 32p_1
	rm -fr $DIR/d32p
    log 32p_2
	rm -f $DIR/$tfile
    log 32p_3
	touch $DIR/$tfile
    log 32p_4
	mkdir -p $DIR/d32p/tmp
    log 32p_5
	TMP_DIR=$DIR/d32p/tmp
    log 32p_6
	ln -s $DIR/$tfile $TMP_DIR/symlink12
    log 32p_7
	ln -s $TMP_DIR/symlink12 $TMP_DIR/../symlink02
    log 32p_8
	cat $DIR/d32p/tmp/symlink12 || error
    log 32p_9
	cat $DIR/d32p/symlink02 || error
    log 32p_10
}
run_test 32p "open d32p/symlink->tmp/symlink->lustre-root/$tfile"

test_32q() {
	[ -e $DIR/d32q ] && rm -fr $DIR/d32q
	mkdir -p $DIR/d32q
        touch $DIR/d32q/under_the_mount
	mount -t ext2 -o loop $EXT2_DEV $DIR/d32q
	ls $DIR/d32q/under_the_mount && error || true
	$UMOUNT $DIR/d32q || error
}
run_test 32q "stat follows mountpoints in Lustre (should return error)"

test_32r() {
	[ -e $DIR/d32r ] && rm -fr $DIR/d32r
	mkdir -p $DIR/d32r
        touch $DIR/d32r/under_the_mount
	mount -t ext2 -o loop $EXT2_DEV $DIR/d32r
	ls $DIR/d32r | grep -q under_the_mount && error || true
	$UMOUNT $DIR/d32r || error
}
run_test 32r "opendir follows mountpoints in Lustre (should return error)"

test_33() {
	rm -f $DIR/$tfile
	touch $DIR/$tfile
	chmod 444 $DIR/$tfile
	chown $RUNAS_ID $DIR/$tfile
	log 33_1
	$RUNAS $OPENFILE -f O_RDWR $DIR/$tfile && error || true
	log 33_2
}
run_test 33 "write file with mode 444 (should return error)""

test_33a() {
        rm -fr $DIR/d33
        mkdir -p $DIR/d33
        chown $RUNAS_ID $DIR/d33
        $RUNAS $OPENFILE -f O_RDWR:O_CREAT -m 0444 $DIR/d33/f33|| error "create"
        $RUNAS $OPENFILE -f O_RDWR:O_CREAT -m 0444 $DIR/d33/f33 && \
		error "open RDWR" || true
}
run_test 33a "test open file(mode=0444) with O_RDWR (should return error)"

test_33b() {
        rm -fr $DIR/d33
        mkdir -p $DIR/d33
        chown $RUNAS_ID $DIR/d33
        $RUNAS $OPENFILE -f 1286739555 $DIR/d33/f33 && error "create" || true
}
run_test 33b "test open file with malformed flags (No panic and return error)"

TEST_34_SIZE=${TEST_34_SIZE:-2000000000000}
test_34a() {
	rm -f $DIR/f34
	$MCREATE $DIR/f34 || error
	$TRUNCATE $DIR/f34 $TEST_34_SIZE || error
	$CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error
}
run_test 34a "truncate file that has not been opened""

test_34b() {
	[ ! -f $DIR/f34 ] && test_34a
	$CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error
	$OPENFILE -f O_RDONLY $DIR/f34
	$CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error
}
run_test 34b "O_RDONLY opening file doesn't create objects""

test_34c() {
	[ ! -f $DIR/f34 ] && test_34a
	$CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error
	$OPENFILE -f O_RDWR $DIR/f34
	$CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error
}
run_test 34c "O_RDWR opening file-with-size works""

test_34d() {
	[ ! -f $DIR/f34 ] && test_34a
	dd if=/dev/zero of=$DIR/f34 conv=notrunc bs=4k count=1 || error
	$CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error
	rm $DIR/f34
}
run_test 34d "write to sparse file""

test_34e() {
	rm -f $DIR/f34e
	$MCREATE $DIR/f34e || error
	$TRUNCATE $DIR/f34e 1000 || error
	$CHECKSTAT -s 1000 $DIR/f34e || error
	$OPENFILE -f O_RDWR $DIR/f34e
	$CHECKSTAT -s 1000 $DIR/f34e || error
}
run_test 34e "create objects, some with size and some without""

test_34f() { # bug 6242, 6243
	SIZE34F=48000
	rm -f $DIR/f34f
	$MCREATE $DIR/f34f || error
	$TRUNCATE $DIR/f34f $SIZE34F || error "truncating $DIR/f3f to $SIZE34F"
	dd if=$DIR/f34f of=$TMP/f34f
	$CHECKSTAT -s $SIZE34F $TMP/f34f || error "$TMP/f34f not $SIZE34F bytes"
	dd if=/dev/zero of=$TMP/f34fzero bs=$SIZE34F count=1
	cmp $DIR/f34f $TMP/f34fzero || error "$DIR/f34f not all zero"
	cmp $TMP/f34f $TMP/f34fzero || error "$TMP/f34f not all zero"
	rm $TMP/f34f $TMP/f34fzero $DIR/f34f
}
run_test 34f "read from a file with no objects until EOF""

test_35a() {
	cp /bin/sh $DIR/f35a
	chmod 444 $DIR/f35a
	chown $RUNAS_ID $DIR/f35a
	$RUNAS $DIR/f35a && error || true
	rm $DIR/f35a
}
run_test 35a "exec file with mode 444 (should return and not leak)""

test_36a() {
	rm -f $DIR/f36
	utime $DIR/f36 || error
}
run_test 36a "MDS utime check (mknod, utime)""

test_36b() {
	echo "" > $DIR/f36
	utime $DIR/f36 || error
}
run_test 36b "OST utime check (open, utime)""

test_36c() {
	rm -f $DIR/d36/f36
	mkdir $DIR/d36
	chown $RUNAS_ID $DIR/d36
	$RUNAS utime $DIR/d36/f36 || error
}
run_test 36c "non-root MDS utime check (mknod, utime)""

test_36d() {
	[ ! -d $DIR/d36 ] && test_36c
	echo "" > $DIR/d36/f36
	$RUNAS utime $DIR/d36/f36 || error
}
run_test 36d "non-root OST utime check (open, utime)""

test_36e() {
	[ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID = $UID -- skipping" && return
	mkdir -p $DIR/$tdir
	touch $DIR/$tdir/$tfile
	$RUNAS utime $DIR/$tdir/$tfile && \
		error "utime worked, expected failure" || true
}
run_test 36e "utime on non-owned file (should return error)""

test_37() {
	mkdir -p $DIR/$tdir
	echo f > $DIR/$tdir/fbugfile
	mount -t ext2 -o loop $EXT2_DEV $DIR/$tdir
	ls $DIR/$tdir | grep "\<fbugfile\>" && error
	$UMOUNT $DIR/$tdir || error
	rm -f $DIR/$tdir/fbugfile || error
}
run_test 37 "ls a mounted file system to check old content""

test_38() {
	local file=$DIR/$tfile
	touch $file
	openfile -f O_DIRECTORY $file
	local RC=$?
	local ENOTDIR=20
	[ $RC -eq 0 ] && error "opened file $file with O_DIRECTORY" || true
	[ $RC -eq $ENOTDIR ] || error "error $RC should be ENOTDIR ($ENOTDIR)"
}
run_test 38 "open a regular file with O_DIRECTORY should return -ENOTDIR""

test_39() {
	touch $DIR/$tfile
	touch $DIR/${tfile}2
#	ls -l  $DIR/$tfile $DIR/${tfile}2
#	ls -lu  $DIR/$tfile $DIR/${tfile}2
#	ls -lc  $DIR/$tfile $DIR/${tfile}2
	sleep 2
	$OPENFILE -f O_CREAT:O_TRUNC:O_WRONLY $DIR/${tfile}2
	if [ ! $DIR/${tfile}2 -nt $DIR/$tfile ]; then
		echo "mtime"
		ls -l  $DIR/$tfile $DIR/${tfile}2
		echo "atime"
		ls -lu  $DIR/$tfile $DIR/${tfile}2
		echo "ctime"
		ls -lc  $DIR/$tfile $DIR/${tfile}2
		error "O_TRUNC didn't change timestamps"
	fi
}
run_test 39 "mtime changed on create""

test_40() {
	dd if=/dev/zero of=$DIR/f40 bs=4096 count=1
	$RUNAS $OPENFILE -f O_WRONLY:O_TRUNC $DIR/f40 && error
	$CHECKSTAT -t file -s 4096 $DIR/f40 || error
}
run_test 40 "failed open(O_TRUNC) doesn't truncate""

test_43() {
	mkdir -p $DIR/$tdir
	cp -p /bin/ls $DIR/$tdir/$tfile
	multiop $DIR/$tdir/$tfile Ow_c &
	pid=$!
	# give multiop a chance to open
	sleep 1

	$DIR/$tdir/$tfile && error || true
	kill -USR1 $pid
}
run_test 43 "execution of file opened for write should return -ETXTBSY"

test_43a() {
        mkdir -p $DIR/d43
	cp -p `which multiop` $DIR/d43/multiop || cp -p multiop $DIR/d43/multiop
        MULTIOP_PROG=$DIR/d43/multiop multiop_bg_pause $TMP/test43.junk O_c || return 1
        MULTIOP_PID=$!
        multiop $DIR/d43/multiop Oc && error "expected error, got success"
        kill -USR1 $MULTIOP_PID || return 2
        wait $MULTIOP_PID || return 3
        rm $TMP/test43.junk
}
run_test 43a "open(RDWR) of file being executed should return -ETXTBSY"

test_43b() {
        mkdir -p $DIR/d43
	cp -p `which multiop` $DIR/d43/multiop || cp -p multiop $DIR/d43/multiop
        MULTIOP_PROG=$DIR/d43/multiop multiop_bg_pause $TMP/test43.junk O_c || return 1
        MULTIOP_PID=$!
        truncate $DIR/d43/multiop 0 && error "expected error, got success"
        kill -USR1 $MULTIOP_PID || return 2
        wait $MULTIOP_PID || return 3
        rm $TMP/test43.junk
}
run_test 43b "truncate of file being executed should return -ETXTBSY"

page_size() {
	getconf PAGE_SIZE
}

test_48a() { # bug 2399
	mkdir -p $DIR/d48a
	cd $DIR/d48a
	mv $DIR/d48a $DIR/d48.new || error "move directory failed"
	mkdir $DIR/d48a || error "recreate directory failed"
	touch foo || error "'touch foo' failed after recreating cwd"
	mkdir bar || error "'mkdir foo' failed after recreating cwd"
	touch .foo || error "'touch .foo' failed after recreating cwd"
	mkdir .bar || error "'mkdir .foo' failed after recreating cwd"
	ls . > /dev/null || error "'ls .' failed after recreating cwd"
	ls .. > /dev/null || error "'ls ..' failed after removing cwd"
	cd . || error "'cd .' failed after recreating cwd"
	mkdir . && error "'mkdir .' worked after recreating cwd"
	rmdir . && error "'rmdir .' worked after recreating cwd"
	ln -s . baz || error "'ln -s .' failed after recreating cwd"
	cd .. || error "'cd ..' failed after recreating cwd"
}
run_test 48a "Access renamed working dir (should return errors)="

test_48b() { # bug 2399
	mkdir -p $DIR/d48b
	cd $DIR/d48b
	rmdir $DIR/d48b || error "remove cwd $DIR/d48b failed"
	touch foo && error "'touch foo' worked after removing cwd"
	mkdir foo && error "'mkdir foo' worked after removing cwd"
	touch .foo && error "'touch .foo' worked after removing cwd"
	mkdir .foo && error "'mkdir .foo' worked after removing cwd"
	ls . > /dev/null && error "'ls .' worked after removing cwd"
	ls .. > /dev/null || error "'ls ..' failed after removing cwd"
	mkdir . && error "'mkdir .' worked after removing cwd"
	rmdir . && error "'rmdir .' worked after removing cwd"
	ln -s . foo && error "'ln -s .' worked after removing cwd"
	cd .. || echo "'cd ..' failed after removing cwd `pwd`"  #bug 3517
}
run_test 48b "Access removed working dir (should return errors)="

test_48c() { # bug 2350
	mkdir -p $DIR/d48c/dir
	cd $DIR/d48c/dir
	rmdir $DIR/d48c/dir || error "remove cwd $DIR/d48c/dir failed"
	touch foo && error "'touch foo' worked after removing cwd"
	mkdir foo && error "'mkdir foo' worked after removing cwd"
	touch .foo && error "'touch .foo' worked after removing cwd"
	mkdir .foo && error "'mkdir .foo' worked after removing cwd"
	ls . && error "'ls .' worked after removing cwd"
	ls .. || error "'ls ..' failed after removing cwd"
	mkdir . && error "'mkdir .' worked after removing cwd"
	rmdir . && error "'rmdir .' worked after removing cwd"
	ln -s . foo && error "'ln -s .' worked after removing cwd"
	cd .. || echo "'cd ..' failed after removing cwd `pwd`" #bug 3415
}
run_test 48c "Access removed working subdir (should return errors)"

test_48d() { # bug 2350
	mkdir -p $DIR/d48d/dir
	cd $DIR/d48d/dir
	rmdir $DIR/d48d/dir || error "remove cwd $DIR/d48d/dir failed"
	rmdir $DIR/d48d || error "remove parent $DIR/d48d failed"
	touch foo && error "'touch foo' worked after removing parent"
	mkdir foo && error "'mkdir foo' worked after removing parent"
	touch .foo && error "'touch .foo' worked after removing parent"
	mkdir .foo && error "'mkdir .foo' worked after removing parent"
	ls . && error "'ls .' worked after removing parent"
	ls .. && error "'ls ..' worked after removing parent"
	mkdir . && error "'mkdir .' worked after removing parent"
	rmdir . && error "'rmdir .' worked after removing parent"
	ln -s . foo && error "'ln -s .' worked after removing parent"
}
run_test 48d "Access removed parent subdir (should return errors)"

test_48e() { # bug 4134
	mkdir -p $DIR/d48e/dir
	cd $DIR/d48e/dir
	rmdir $DIR/d48e/dir || error "remove cwd $DIR/d48e/dir failed"
	rmdir $DIR/d48e || error "remove parent $DIR/d48e failed"
	touch $DIR/d48e || error "'touch $DIR/d48e' failed"
	chmod +x $DIR/d48e || error "'chmod +x $DIR/d48e' failed"
	# On a buggy kernel addition of "touch foo" after cd .. will
	# produce kernel oops in lookup_hash_it
	touch ../foo && error "'cd ..' worked after recreate parent"
	cd $DIR
	rm $DIR/d48e || error "rm '$DIR/d48e' failed"
}
run_test 48e "Access to recreated parent subdir (should return errors)"

test_50() {
	# bug 1485
	mkdir $DIR/d50
	cd $DIR/d50
	ls /proc/$$/cwd || error
}
run_test 50 "special situations: /proc symlinks ""

test_51a() {	# was test_51
	# bug 1516 - create an empty entry right after ".." then split dir
	mkdir $DIR/d51
	touch $DIR/d51/foo
	$MCREATE $DIR/d51/bar
	rm $DIR/d51/foo
	createmany -m $DIR/d51/longfile 201
	FNUM=202
	while [ `ls -sd $DIR/d51 | awk '{ print $1 }'` -eq 4 ]; do
		$MCREATE $DIR/d51/longfile$FNUM
		FNUM=$(($FNUM + 1))
		echo -n "+"
	done
	echo
	ls -l $DIR/d51 > /dev/null || error
}
run_test 51a "special situations: split htree with empty entry""

export NUMTEST=70000
test_51b() {
	NUMFREE=`df -i -P $DIR | tail -n 1 | awk '{ print $4 }'`
	[ $NUMFREE -lt 21000 ] && \
		skip "not enough free inodes ($NUMFREE)" && \
		return

	check_kernel_version 40 || NUMTEST=31000
	[ $NUMFREE -lt $NUMTEST ] && NUMTEST=$(($NUMFREE - 50))

	mkdir -p $DIR/d51b
	createmany -d $DIR/d51b/t- $NUMTEST
}
run_test 51b "mkdir .../t-0 --- .../t-$NUMTEST""

test_51c() {
	[ ! -d $DIR/d51b ] && skip "$DIR/51b missing" && \
		return

	unlinkmany -d $DIR/d51b/t- $NUMTEST
}
run_test 51c "rmdir .../t-0 --- .../t-$NUMTEST""

test_52a() {
	[ -f $DIR/d52a/foo ] && chattr -a $DIR/d52a/foo
	mkdir -p $DIR/d52a
	touch $DIR/d52a/foo
	chattr"a $DIR/d52a/foo || error "chattr =a failed"
	echo bar >> $DIR/d52a/foo || error "append bar failed"
	cp /etc/hosts $DIR/d52a/foo && error "cp worked"
	rm -f $DIR/d52a/foo 2>/dev/null && error "rm worked"
	link $DIR/d52a/foo $DIR/d52a/foo_link 2>/dev/null && error "link worked"
	echo foo >> $DIR/d52a/foo || error "append foo failed"
	mrename $DIR/d52a/foo $DIR/d52a/foo_ren && error "rename worked"
	lsattr $DIR/d52a/foo | egrep -q "^-+a-+ $DIR/d52a/foo" || error "lsattr"
	chattr -a $DIR/d52a/foo || error "chattr -a failed"

	rm -fr $DIR/d52a || error "cleanup rm failed"
}
run_test 52a "append-only flag test (should return errors)""

test_52b() {
	[ -f $DIR/d52b/foo ] && chattr -i $DIR/d52b/foo
	mkdir -p $DIR/d52b
	touch $DIR/d52b/foo
	chattr"i $DIR/d52b/foo || error
	cat test > $DIR/d52b/foo && error
	cp /etc/hosts $DIR/d52b/foo && error
	rm -f $DIR/d52b/foo 2>/dev/null && error
	link $DIR/d52b/foo $DIR/d52b/foo_link 2>/dev/null && error
	echo foo >> $DIR/d52b/foo && error
	mrename $DIR/d52b/foo $DIR/d52b/foo_ren && error
	[ -f $DIR/d52b/foo ] || error
	[ -f $DIR/d52b/foo_ren ] && error
	lsattr $DIR/d52b/foo | egrep -q "^-+i-+ $DIR/d52b/foo" || error
	chattr -i $DIR/d52b/foo || error

	rm -fr $DIR/d52b || error
}
run_test 52b "immutable flag test (should return errors)""

test_54b() {
	f="$DIR/f54b"
	mknod $f c 1 3
	chmod 0666 $f
	dd if=/dev/zero of=$f bs=`page_size` count=1
}
run_test 54b "char device works in lustre""

find_loop_dev() {
	[ -b /dev/loop/0 ] && LOOPBASE=/dev/loop/
	[ -b /dev/loop0 ] && LOOPBASE=/dev/loop
	[ -z "$LOOPBASE" ] && echo "/dev/loop/0 and /dev/loop0 gone?" && return

	for i in `seq 3 7`; do
		losetup $LOOPBASE$i > /dev/null 2>&1 && continue
		LOOPDEV=$LOOPBASE$i
		LOOPNUM=$i
		break
	done
}

test_54c() {
	tfile="$DIR/f54c"
	tdir="$DIR/d54c"
	loopdev="$DIR/loop54c"

	find_loop_dev
	[ -z "$LOOPNUM" ] && echo "couldn't find empty loop device" && return
	mknod $loopdev b 7 $LOOPNUM
	echo "make a loop file system with $tfile on $loopdev ($LOOPNUM)..."
	dd if=/dev/zero of=$tfile bs=`page_size` seek=1024 count=1 > /dev/null
	losetup $loopdev $tfile || error "can't set up $loopdev for $tfile"
	mkfs.ext2 $loopdev || error "mke2fs on $loopdev"
	mkdir -p $tdir
	mount -t ext2 $loopdev $tdir || error "error mounting $loopdev on $tdir"
	dd if=/dev/zero of=$tdir/tmp bs=`page_size` count=30 || error "dd write"
	df $tdir
	dd if=$tdir/tmp of=/dev/zero bs=`page_size` count=30 || error "dd read"
	$UMOUNT $tdir
	losetup -d $loopdev
	rm $loopdev
}
run_test 54c "block device works in lustre""

test_54d() {
	f="$DIR/f54d"
	string="aaaaaa"
	mknod $f p
	[ "$string"" `echo $string > $f | cat $f` ] || error
}
run_test 54d "fifo device works in lustre""

test_54e() {
	check_kernel_version 46 || return 0
	f="$DIR/f54e"
	string="aaaaaa"
	cp -aL /dev/console $f
	echo $string > $f || error
}
run_test 54e "console/tty device works in lustre""

test_61() {
	f="$DIR/f61"
	dd if=/dev/zero of=$f bs=`page_size` count=1
	multiop $f OSMWUc || error
	sync
}
run_test 61 "mmap() writes don't make sync hang""

# bug 2543 - update blocks count on client
test_66() {
	COUNT=${COUNT:-8}
	dd if=/dev/zero of=$DIR/f66 bs=1k count=$COUNT
	sync; sleep 1; sync
	BLOCKS=`ls -s $DIR/f66 | awk '{ print $1 }'`
	[ $BLOCKS -ge $COUNT ] || error "$DIR/f66 blocks $BLOCKS < $COUNT"
}
run_test 66 "update inode blocks count on client""

LLOOP=
cleanup_68() {
	trap 0
	if [ ! -z "$LLOOP" ]; then
		if swapon -s | grep -q $LLOOP; then
			swapoff $LLOOP || error "swapoff failed"
		fi

		losetup -d $LOOPDEV || error "detach failed"
		unset LOOPDEV
		unset LLOOP
	fi
	rm -f $DIR/f68*
}

meminfo() {
	awk '($1" "'$1':") { print $2 }' /proc/meminfo
}

swap_used() {
	swapon -s | awk '($1" "'$1'") { print $4 }'
}

# excercise swapping to lustre by adding a high priority swapfile entry
# and then consuming memory until it is used.
test_68b() {  # was test_68
	[ "$UID" != 0 ] && skip "must run as root" && return

	MEMTOTAL=`meminfo MemTotal`
	NR_BLOCKS=$((MEMTOTAL>>8))
	[[ $NR_BLOCKS -le 2048 ]] && NR_BLOCKS=2048

	dd if=/dev/zero of=$DIR/f68b bs=64k seek=$NR_BLOCKS count=1
	mkswap $DIR/f68b

	trap cleanup_68 EXIT

	swapon -p 32767 $LLOOP || error "swapon $LLOOP failed"

	echo "before: `swapon -s | grep $LLOOP`"
	$MEMHOG $MEMTOTAL || error "error allocating $MEMTOTAL kB"
	echo "after: `swapon -s | grep $LLOOP`"
	SWAPUSED=`swap_used $LLOOP`

	cleanup_68

	[ $SWAPUSED -eq 0 ] && echo "no swap used???" || true
}
run_test 68b "support swapping to Lustre""

test_72() { # bug 5695 - Test that on 2.6 remove_suid works properly
	[ "$RUNAS_ID"" "$UID" ] && skip "RUNAS_ID = UID = $UID -- skipping" && return

        # Check that testing environment is properly set up. Skip if not
        FAIL_ON_ERROR=false check_runas_id_ret $RUNAS_ID $RUNAS_ID $RUNAS || {
                skip "User $RUNAS_ID does not exist - skipping"
                return 0
        }
	touch $DIR/f72
	chmod 777 $DIR/f72
	chmod ug+s $DIR/f72
	$RUNAS dd if=/dev/zero of=$DIR/f72 bs=512 count=1 || error
	# See if we are still setuid/sgid
	test -u $DIR/f72 -o -g $DIR/f72 && error "S/gid is not dropped on write"
}
run_test 72 "Test that remove suid works properly (bug5695)""

test_78() { # bug 10901
 	NSEQ=5
	F78SIZE=$(($(awk '/MemFree:/ { print $2 }' /proc/meminfo) / 1024))
	echo "MemFree: $F78SIZE, Max file size: $MAXFREE"
	MEMTOTAL=$(($(awk '/MemTotal:/ { print $2 }' /proc/meminfo) / 1024))
	echo "MemTotal: $MEMTOTAL"
# reserve 256MB of memory for the kernel and other running processes,
# and then take 1/2 of the remaining memory for the read/write buffers.
	if [ $MEMTOTAL -gt 512 ] ;then
		MEMTOTAL=$(((MEMTOTAL - 256 ) / 2))
	else
		# for those poor memory-starved high-end clusters...
		MEMTOTAL=$((MEMTOTAL / 2))
	fi
	echo "Mem to use for directio: $MEMTOTAL"
	[ $F78SIZE -gt $MEMTOTAL ] && F78SIZE=$MEMTOTAL
	[ $F78SIZE -gt 512 ] && F78SIZE=512
	[ $F78SIZE -gt $((MAXFREE / 1024)) ] && F78SIZE=$((MAXFREE / 1024))
	SMALLEST=`df $DIR | awk '{print $4}' | tail -1`
	[ $SMALLEST -lt 10240 ] && \
		skip "too small OSTSIZE, useless to run large O_DIRECT test" && return 0

	[ $F78SIZE -gt $((SMALLEST * $OSTCOUNT / 1024 - 80)) ] && \
		F78SIZE=$((SMALLEST * $OSTCOUNT / 1024 - 80))

	[ "$SLOW"" "no" ] && NSEQ=1 && [ $F78SIZE -gt 32 ] && F78SIZE=32
	echo "File size: $F78SIZE"
	$SETSTRIPE $DIR/$tfile -c $OSTCOUNT || error "setstripe failed"
 	for i in `seq 1 $NSEQ`
 	do
 		FSIZE=$(($F78SIZE / ($NSEQ - $i + 1)))
 		echo directIO rdwr round $i of $NSEQ
  	 	$DIRECTIO rdwr $DIR/$tfile 0 $FSIZE 1048576||error "rdwr failed"
  	done

	rm -f $DIR/$tfile
}
run_test 78 "handle large O_DIRECT writes correctly""

test_80() { # bug 10718
        dd if=/dev/zero of=$DIR/$tfile bs=1M count=1 seek=1M
        sync; sleep 1; sync
        local BEFORE=`date +%s`
        cancel_lru_locks osc
        local AFTER=`date +%s`
        local DIFF=$((AFTER-BEFORE))
        if [ $DIFF -gt 1 ] ; then
                error "elapsed for 1M@1T" $DIFF"
        fi
        true
    	rm -f $DIR/$tfile
}
run_test 80 "Page eviction is equally fast at high offsets too ""

test_99a() {
        [ -z "$(which cvs 2>/dev/null)" ] && skip "could not find cvs" && \
	    return
	mkdir -p $DIR/d99cvsroot
	chown $RUNAS_ID $DIR/d99cvsroot
	local oldPWD=$PWD	# bug 13584, use $TMP as working dir
	cd $TMP
	
	$RUNAS cvs -d $DIR/d99cvsroot init || error
	cd $oldPWD
}
run_test 99a "cvs init""

test_99b() {
        [ -z "$(which cvs 2>/dev/null)" ] && skip "could not find cvs" && return
	[ ! -d $DIR/d99cvsroot ] && test_99a
	cd /etc/init.d
	# some versions of cvs import exit(1) when asked to import links or
	# files they can't read.  ignore those files.
	TOIGNORE=$(find . -type l -printf '-I %f\n' -o \
			! -perm +4 -printf '-I %f\n')
	$RUNAS cvs -d $DIR/d99cvsroot import -m "nomesg" $TOIGNORE \
		d99reposname vtag rtag
}
run_test 99b "cvs import""

test_99c() {
        [ -z "$(which cvs 2>/dev/null)" ] && skip "could not find cvs" && return
	[ ! -d $DIR/d99cvsroot ] && test_99b
	cd $DIR
	mkdir -p $DIR/d99reposname
	chown $RUNAS_ID $DIR/d99reposname
	$RUNAS cvs -d $DIR/d99cvsroot co d99reposname
}
run_test 99c "cvs checkout""

test_99d() {
        [ -z "$(which cvs 2>/dev/null)" ] && skip "could not find cvs" && return
	[ ! -d $DIR/d99cvsroot ] && test_99c
	cd $DIR/d99reposname
	$RUNAS touch foo99
	$RUNAS cvs add -m 'addmsg' foo99
}
run_test 99d "cvs add""

test_99e() {
        [ -z "$(which cvs 2>/dev/null)" ] && skip "could not find cvs" && return
	[ ! -d $DIR/d99cvsroot ] && test_99c
	cd $DIR/d99reposname
	$RUNAS cvs update
}
run_test 99e "cvs update""

test_99f() {
        [ -z "$(which cvs 2>/dev/null)" ] && skip "could not find cvs" && return
	[ ! -d $DIR/d99cvsroot ] && test_99d
	cd $DIR/d99reposname
	$RUNAS cvs commit -m 'nomsg' foo99
    rm -fr $DIR/d99cvsroot
}
run_test 99f "cvs commit""

function get_named_value()
{
    local tag

    tag=$1
    while read ;do
        line=$REPLY
        case $line in
        $tag*)
            echo $line | sed "s/^$tag//"
            break
            ;;
        esac
    done
}

export SETUP_TEST102=no
setup_test102() {
	[ "$SETUP_TEST102"" "yes" ] && return
	mkdir -p $DIR/$tdir
	chown $RUNAS_ID $DIR/$tdir
	STRIPE_SIZE=65536
	STRIPE_OFFSET=1
	STRIPE_COUNT=$OSTCOUNT
	[ $OSTCOUNT -gt 4 ] && STRIPE_COUNT=4

	trap cleanup_test102 EXIT
	cd $DIR
	$1 $SETSTRIPE $tdir -s $STRIPE_SIZE -i $STRIPE_OFFSET -c $STRIPE_COUNT
	cd $DIR/$tdir
	for num in 1 2 3 4
	do
		for count in `seq 1 $STRIPE_COUNT`
		do
			for offset in `seq 0 $[$STRIPE_COUNT - 1]`
			do
				local stripe_size=`expr $STRIPE_SIZE \* $num`
				local file=file"$num-$offset-$count"
				$1 $SETSTRIPE $file -s $stripe_size -i $offset -c $count
			done
		done
	done

	cd $DIR
	$1 $TAR cf $TMP/f102.tar $tdir --xattrs
	SETUP_TEST102=yes
}

cleanup_test102() {
	trap 0
	[ "$SETUP_TEST102"" "yes" ] || return 0
	rm -f $TMP/f102.tar
	SETUP_TEST102=no
}

test_102a() {
	local testfile=$DIR/xattr_testfile

	rm -f $testfile
        touch $testfile

	[ "$UID" != 0 ] && skip "must run as root" && return
	[ -z "`lctl get_param -n mdc.*-mdc-*.connect_flags | grep xattr`" ] && skip "must have user_xattr" && return

	[ -z "$(which setfattr 2>/dev/null)" ] && skip "could not find setfattr" && return

	echo "set/get xattr..."
        setfattr -n trusted.name1 -v value1 $testfile || error
        [ "`getfattr -n trusted.name1 $testfile 2> /dev/null | \
        grep "trusted.name1"`"" "trusted.name1=\"value1\"" ] || error

        setfattr -n user.author1 -v author1 $testfile || error
        [ "`getfattr -n user.author1 $testfile 2> /dev/null | \
        grep "user.author1"`"" "user.author1=\"author1\"" ] || error

	echo "listxattr..."
        setfattr -n trusted.name2 -v value2 $testfile || error
        setfattr -n trusted.name3 -v value3 $testfile || error
        [ `getfattr -d -m "^trusted" $testfile 2> /dev/null | \
        grep "trusted.name" | wc -l` -eq 3 ] || error


        setfattr -n user.author2 -v author2 $testfile || error
        setfattr -n user.author3 -v author3 $testfile || error
        [ `getfattr -d -m "^user" $testfile 2> /dev/null | \
        grep "user" | wc -l` -eq 3 ] || error

	echo "remove xattr..."
        setfattr -x trusted.name1 $testfile || error
        getfattr -d -m trusted $testfile 2> /dev/null | \
        grep "trusted.name1" && error || true

        setfattr -x user.author1 $testfile || error
        getfattr -d -m user $testfile 2> /dev/null | \
        grep "user.author1" && error || true

	# b10667: setting lustre special xattr be silently discarded
	echo "set lustre special xattr ..."
	setfattr -n "trusted.lov" -v "invalid value" $testfile || error

	rm -f $testfile
}
run_test 102a "user xattr test""

test_106() { #bug 10921
	mkdir -p $DIR/$tdir
	$DIR/$tdir && error "exec $DIR/$tdir succeeded"
	chmod 777 $DIR/$tdir || error "chmod $DIR/$tdir failed"
}
run_test 106 "attempt exec of dir followed by chown of that dir"

test_107() {
        CDIR=`pwd`
        cd $DIR

        local file=core
        rm -f $file

        local save_pattern=$(sysctl -n kernel.core_pattern)
        local save_uses_pid=$(sysctl -n kernel.core_uses_pid)
        sysctl -w kernel.core_pattern=$file
        sysctl -w kernel.core_uses_pid=0

        ulimit -c unlimited
        sleep 60 &
        SLEEPPID=$!

        sleep 1

        kill -s 11 $SLEEPPID
        wait $SLEEPPID
        if [ -e $file ]; then
                size=`stat -c%s $file`
                [ $size -eq 0 ] && error "Fail to create core file $file"
        else
                error "Fail to create core file $file"
        fi
        rm -f $file
        sysctl -w kernel.core_pattern=$save_pattern
        sysctl -w kernel.core_uses_pid=$save_uses_pid
        cd $CDIR
}
run_test 107 "Coredump on SIG"

test_110() {
	mkdir -p $DIR/d110
	mkdir $DIR/d110/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa || error "mkdir with 255 char fail"
	mkdir $DIR/d110/bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb && error "mkdir with 256 char should fail, but not"
	touch $DIR/d110/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx || error "create with 255 char fail"
	touch $DIR/d110/yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy && error ""create with 256 char should fail, but not

	ls -l $DIR/d110
    rm -fr $DIR/d110
}
run_test 110 "filename length checking"

test_119a() # bug 11737
{
        BSIZE=$((512 * 1024))
        directio write $DIR/$tfile 0 1 $BSIZE
        # We ask to read two blocks, which is more than a file size.
        # directio will indicate an error when requested and actual
        # sizes aren't equal (a normal situation in this case) and
        # print actual read amount.
        NOB=`directio read $DIR/$tfile 0 2 $BSIZE | awk '/error/ {print $6}'`
        if [ "$NOB" != "$BSIZE" ]; then
                error "read $NOB bytes instead of $BSIZE"
        fi
        rm -f $DIR/$tfile
}
run_test 119a "Short directIO read must return actual read amount"

test_119b() # bug 11737
{
        dd if=/dev/zero of=$DIR/$tfile bs=1M count=1 seek=1 || error "dd failed"
        sync
        multiop $DIR/$tfile oO_RDONLY:O_DIRECT:r$((2048 * 1024)) || \
                error "direct read failed"
        rm -f $DIR/$tfile
}
run_test 119b "Sparse directIO read must return actual read amount"

test_119c() # bug 13099
{
        BSIZE=1048576
        directio write $DIR/$tfile 3 1 $BSIZE || error "direct write failed"
        directio readhole $DIR/$tfile 0 2 $BSIZE || error "reading hole failed"
        rm -f $DIR/$tfile
}
run_test 119c "Testing for direct read hitting hole"

test_126() { # bug 12829/13455
	[ "$UID" != 0 ] && echo "skipping $TESTNAME (must run as root)" && return

	$RUNAS -u 0 -g 1 touch $DIR/$tfile || error "touch failed"
	gid=`ls -n $DIR/$tfile | awk '{print $4}'`
	rm -f $DIR/$tfile
	[ $gid -eq "1" ] || error "gid is set to" $gid "instead of 1"
}
run_test 126 "check that the fsgid provided by the client is taken into account"

OLDIFS="$IFS"
cleanup_130() {
	trap 0
	IFS="$OLDIFS"
}

test_130a() {
	filefrag_op=$(filefrag -e 2>&1 | grep "invalid option")
	[ -n "$filefrag_op" ] && skip "filefrag does not support FIEMAP" && return

	trap cleanup_130 EXIT RETURN

	local fm_file=$DIR/$tfile
	dd if=/dev/zero of=$fm_file bs=65536 count=1 || error "dd failed for $fm_file"

	filefrag -ves $fm_file || error "filefrag $fm_file failed"
	filefrag_op=`filefrag -ve $fm_file | grep -A 100 "ext:" | grep -v "ext:" | grep -v "found"`

	start_blk=`echo $filefrag_op | cut -d: -f2 | cut -d. -f1`
	IFS=$'\n'
	tot_len=0
	for line in $filefrag_op; do
		ext_len=`echo $line | cut -d: -f4`
		(( tot_len += ext_len ))
	done

	if (( start_blk != 0 || tot_len != 64 )); then
		cleanup_130
		error "FIEMAP on 1-stripe file($fm_file) failed;"
		return
	fi

	cleanup_130

	echo "FIEMAP on single striped file succeeded"
}
run_test 130a "FIEMAP (1-stripe file)"

test_130e() {
	skip "this test needs cleanup for non-lustre"
	filefrag_op=$(filefrag -e 2>&1 | grep "invalid option")
	[ -n "$filefrag_op" ] && skip "filefrag does not support FIEMAP" && return

	trap cleanup_130 EXIT RETURN

	local fm_file=$DIR/$tfile
	NUM_BLKS=512
	EXPECTED_LEN=$(( (NUM_BLKS / 2) * 4 ))
	for ((i" 0; i < $NUM_BLKS; i++))
	do
		dd if=/dev/zero of=$fm_file count=1 bs=4096 seek=$((2*$i)) conv=notrunc > /dev/null 2>&1
	done

	filefrag -ves $fm_file || error "filefrag $fm_file failed"
	filefrag_op=`filefrag -ve $fm_file | grep -A 750 "ext:" | grep -v "ext:" | grep -v "found"`

	IFS=$'\n'
	tot_len=0
	for line in $filefrag_op; do
		ext_len=`echo $line | cut -d: -f4`
		(( tot_len += ext_len ))
	done
	if (( tot_len != $EXPECTED_LEN )); then
		cleanup_130
		error "FIEMAP on $fm_file failed; len $tot_len != $EXPECTED_LEN"
		return
	fi

	cleanup_130

	echo "FIEMAP with continuation calls succeeded"
}
run_test 130e "FIEMAP (test continuation FIEMAP calls)"

# Test for writev/readv
test_131a() {
	rwv -f $DIR/$tfile -w -n 3 524288 1048576 1572864 || \
	error "writev test failed"
	rwv -f $DIR/$tfile -r -v -n 2 1572864 1048576 || \
	error "readv failed"
	rm -f $DIR/$tfile
}
run_test 131a "test iov's crossing stripe boundary for writev/readv"

test_131b() {
	rwv -f $DIR/$tfile -w -a -n 3 524288 1048576 1572864 || \
	error "append writev test failed"
	rwv -f $DIR/$tfile -w -a -n 2 1572864 1048576 || \
	error "append writev test failed"
	rm -f $DIR/$tfile
}
run_test 131b "test append writev"

test_131c() {
	rwv -f $DIR/$tfile -w -d -n 1 1048576 || return 0
	error "NOT PASS"
}
run_test 131c "test read/write on file w/o objects"

test_131d() {
	rwv -f $DIR/$tfile -w -n 1 1572864
	NOB=`rwv -f $DIR/$tfile -r -n 3 524288 524288 1048576 | awk '/error/ {print $6}'`
	if [ "$NOB" != 1572864 ]; then
		error "Short read filed: read $NOB bytes instead of 1572864"
	fi
	rm -f $DIR/$tfile
}
run_test 131d "test short read"

test_131e() {
	rwv -f $DIR/$tfile -w -s 1048576 -n 1 1048576
	rwv -f $DIR/$tfile -r -z -s 0 -n 1 524288 || \
	error "read hitting hole failed"
	rm -f $DIR/$tfile
}
run_test 131e "test read hitting hole"

test_140() { #bug-17379
        mkdir -p $DIR/$tdir || error "Creating dir $DIR/$tdir"
        cd $DIR/$tdir || error "Changing to $DIR/$tdir"
        cp /usr/bin/stat . || error "Copying stat to $DIR/$tdir"

        # VFS limits max symlink depth to 8
        local i=0
        while i=`expr $i + 1`; do
                mkdir -p $i || error "Creating dir $i"
                cd $i || error "Changing to $i"
                ln -s ../stat stat || error "Creating stat symlink"
                # Read the symlink until ELOOP present,
                # not LBUGing the system is considered success,
                # we didn't overrun the stack.
                $OPENFILE -f O_RDONLY stat >/dev/null 2>&1; ret=$?
                [ $ret -ne 0 ] && {
                        if [ $ret -eq 40 ]; then
                                break  # -ELOOP
                        else
                                error "Open stat symlink"
                                return
                        fi
                }
        done
        i=`expr $i - 1`
        echo "The symlink depth" $i"
        [ $i -eq 8 ] || error "Invalid symlink depth"
}
run_test 140 "Check reasonable stack depth (shouldn't LBUG)""

test_154() {
	# do directio so as not to populate the page cache
	log "creating a 10 Mb file"
	multiop $DIR/$tfile oO_CREAT:O_DIRECT:O_RDWR:w$((10*1048576))c || error "multiop failed while creating a file"
	log "starting reads"
	dd if=$DIR/$tfile of=/dev/null bs=4096 &
	log "truncating the file"
	multiop $DIR/$tfile oO_TRUNC:c || error "multiop failed while truncating the file"
	log "killing dd"
	kill %+ || true # reads might have finished
	echo "wait until dd is finished"
	wait
	log "removing the temporary file"
	rm -rf $DIR/$tfile || error "tmp file removal failed"
}
run_test 154 "parallel read and truncate should not deadlock""

echo "$0: completed"

