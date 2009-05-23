From: Subrata Modak <tosubrata-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Lustre basic tests script
Date: Sat, 23 May 2009 16:33:47 +0530
Message-ID: <bb33bcf20905230403n2e959d8fg1f463539b7cdb445@mail.gmail.com>
References: <20090522213639.GC13578@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3634720694974603220=="
Cc: LTP <ltp-list-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Andreas Dilger <adilger-xsfywfwIY+M@public.gmane.org>
Return-path: <ltp-list-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20090522213639.GC13578-RIaA196FMs1uuQVovAj/GogTZbYi8/ss@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ltp-list>,
	<mailto:ltp-list-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=ltp-list>
List-Post: <mailto:ltp-list-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:ltp-list-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ltp-list>,
	<mailto:ltp-list-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: ltp-list-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

--===============3634720694974603220==
Content-Type: multipart/alternative; boundary=00163646c228cdfa43046a925441

--00163646c228cdfa43046a925441
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Andreas,

On Sat, May 23, 2009 at 3:06 AM, Andreas Dilger <adilger-xsfywfwIY+M@public.gmane.org> wrote:

> Below are included some of the tests from the Lustre "sanity.sh" script,
> which tests filesystem behaviour in a variety of ways.  Some of them are
> very simple and might concievably be removed, but are not necessarily bad=
.
> I've removed the tests that depend on Lustre-specific behaviour.
>
> It probably isn't useful to use this test script directly, since it
> depends on a number of helper functions, but it is definitely useful
> as a starting point for adding new tests to xfstests.
>
> Unfortunately, a bunch of tests had to be removed since they depend on
> Lustre's fault-injection code, but they would be useful for testing
> generic filesystem behaviour (e.g. ENOMEM or ENOSPC handling).  There
> is also a helper program we use "multiop" which is a toolbox program
> that I could supply separately, if you want.


How about understanding these and find out if they can be made part of LTP
as well  ? Any objection(s) ?

Regards--
Subrata


>
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>
> TMP=3D${TMP:-/tmp}
>
> [ -f $DIR/d52a/foo ] && chattr -a $DIR/d52a/foo
> [ -f $DIR/d52b/foo ] && chattr -i $DIR/d52b/foo
> rm -rf $DIR/[Rdfs][0-9]*
>
> # $RUNAS_ID may get set incorrectly somewhere else
> [ $UID -eq 0 -a $RUNAS_ID -eq 0 ] && error "\$RUNAS_ID set to 0, but \$UI=
D
> is also 0!"
>
>
> echo "preparing for tests involving mounts"
> EXT2_DEV=3D${EXT2_DEV:-$TMP/SANITY.LOOP}
> touch $EXT2_DEV
> mke2fs -j -F $EXT2_DEV 8000 > /dev/null
> echo # add a newline after mke2fs.
>
> umask 077
>
> test_0() {
>        touch $DIR/$tfile
>        $CHECKSTAT -t file $DIR/$tfile || error
>        rm $DIR/$tfile
>        $CHECKSTAT -a $DIR/$tfile || error
> }
> run_test 0 "touch .../$tfile ; rm .../$tfile"
>
> test_0b() {
>        chmod 0755 $DIR || error
>        $CHECKSTAT -p 0755 $DIR || error
> }
> run_test 0b "chmod 0755 $DIR"
>
> test_1a() {
>        mkdir $DIR/d1
>        mkdir $DIR/d1/d2
>        mkdir $DIR/d1/d2 && error "we expect EEXIST, but not returned"
>        $CHECKSTAT -t dir $DIR/d1/d2 || error
> }
> run_test 1a "mkdir .../d1; mkdir .../d1/d2"
>
> test_1b() {
>        rmdir $DIR/d1/d2
>        rmdir $DIR/d1
>        $CHECKSTAT -a $DIR/d1 || error
> }
> run_test 1b "rmdir .../d1/d2; rmdir .../d1"
>
> test_2a() {
>        mkdir $DIR/d2
>        touch $DIR/d2/f
>        $CHECKSTAT -t file $DIR/d2/f || error
> }
> run_test 2a "mkdir .../d2; touch .../d2/f"
>
> test_2b() {
>        rm -r $DIR/d2
>        $CHECKSTAT -a $DIR/d2 || error
> }
> run_test 2b "rm -r .../d2; checkstat .../d2/f"
>
> test_3a() {
>        mkdir $DIR/d3
>        $CHECKSTAT -t dir $DIR/d3 || error
> }
> run_test 3a "mkdir .../d3"
>
> test_3b() {
>        if [ ! -d $DIR/d3 ]; then
>                mkdir $DIR/d3
>        fi
>        touch $DIR/d3/f
>        $CHECKSTAT -t file $DIR/d3/f || error
> }
> run_test 3b "touch .../d3/f"
>
> test_3c() {
>        rm -r $DIR/d3
>        $CHECKSTAT -a $DIR/d3 || error
> }
> run_test 3c "rm -r .../d3"
>
> test_4a() {
>        mkdir $DIR/d4
>        $CHECKSTAT -t dir $DIR/d4 || error
> }
> run_test 4a "mkdir .../d4"
>
> test_4b() {
>        if [ ! -d $DIR/d4 ]; then
>                mkdir $DIR/d4
>        fi
>        mkdir $DIR/d4/d2
>        $CHECKSTAT -t dir $DIR/d4/d2 || error
> }
> run_test 4b "mkdir .../d4/d2"
>
> test_5() {
>        mkdir $DIR/d5
>        mkdir $DIR/d5/d2
>        chmod 0707 $DIR/d5/d2
>        $CHECKSTAT -t dir -p 0707 $DIR/d5/d2 || error
> }
> run_test 5 "mkdir .../d5 .../d5/d2; chmod .../d5/d2"
>
> test_6a() {
>        touch $DIR/f6a
>        chmod 0666 $DIR/f6a || error
>        $CHECKSTAT -t file -p 0666 -u \#$UID $DIR/f6a || error
> }
> run_test 6a "touch .../f6a; chmod .../f6a"
>
> test_6b() {
>        [ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID =3D $UID -- skipping=
" &&
> return
>        if [ ! -f $DIR/f6a ]; then
>                touch $DIR/f6a
>                chmod 0666 $DIR/f6a
>        fi
>        $RUNAS chmod 0444 $DIR/f6a && error
>        $CHECKSTAT -t file -p 0666 -u \#$UID $DIR/f6a || error
> }
> run_test 6b "$RUNAS chmod .../f6a (should return error)""
>
> test_6c() {
>        [ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID =3D $UID -- skipping=
" &&
> return
>        touch $DIR/f6c
>        chown $RUNAS_ID $DIR/f6c || error
>        $CHECKSTAT -t file -u \#$RUNAS_ID $DIR/f6c || error
> }
> run_test 6c "touch .../f6c; chown .../f6c"
>
> test_6d() {
>        [ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID =3D $UID -- skipping=
" &&
> return
>        if [ ! -f $DIR/f6c ]; then
>                touch $DIR/f6c
>                chown $RUNAS_ID $DIR/f6c
>        fi
>        $RUNAS chown $UID $DIR/f6c && error
>        $CHECKSTAT -t file -u \#$RUNAS_ID $DIR/f6c || error
> }
> run_test 6d "$RUNAS chown .../f6c (should return error)""
>
> test_6e() {
>        [ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID =3D $UID -- skipping=
" &&
> return
>        touch $DIR/f6e
>        chgrp $RUNAS_ID $DIR/f6e || error
>        $CHECKSTAT -t file -u \#$UID -g \#$RUNAS_ID $DIR/f6e || error
> }
> run_test 6e "touch .../f6e; chgrp .../f6e"
>
> test_6f() {
>        [ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID =3D $UID -- skipping=
" &&
> return
>        if [ ! -f $DIR/f6e ]; then
>                touch $DIR/f6e
>                chgrp $RUNAS_ID $DIR/f6e
>        fi
>        $RUNAS chgrp $UID $DIR/f6e && error
>        $CHECKSTAT -t file -u \#$UID -g \#$RUNAS_ID $DIR/f6e || error
> }
> run_test 6f "$RUNAS chgrp .../f6e (should return error)""
>
> test_6g() {
>        [ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID =3D $UID -- skipping=
" &&
> return
>        mkdir $DIR/d6g || error
>        chmod 777 $DIR/d6g || error
>        $RUNAS mkdir $DIR/d6g/d || error
>        chmod g+s $DIR/d6g/d || error
>        mkdir $DIR/d6g/d/subdir
>        $CHECKSTAT -g \#$RUNAS_ID $DIR/d6g/d/subdir || error
> }
> run_test 6g "Is new dir in sgid dir inheriting group?"
>
> test_6h() { # bug 7331
>        [ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID =3D $UID -- skipping=
" &&
> return
>        touch $DIR/f6h || error "touch failed"
>        chown $RUNAS_ID:$RUNAS_ID $DIR/f6h || error "initial chown failed"
>        $RUNAS -G$RUNAS_ID chown $RUNAS_ID:0 $DIR/f6h && error "chown
> worked"
>        $CHECKSTAT -t file -u \#$RUNAS_ID -g \#$RUNAS_ID $DIR/f6h || error
> }
> run_test 6h "$RUNAS chown RUNAS_ID.0 .../f6h (should return error)"
>
> test_7a() {
>        mkdir $DIR/d7
>        $MCREATE $DIR/d7/f
>        chmod 0666 $DIR/d7/f
>        $CHECKSTAT -t file -p 0666 $DIR/d7/f || error
> }
> run_test 7a "mkdir .../d7; mcreate .../d7/f; chmod .../d7/f""
>
> test_7b() {
>        if [ ! -d $DIR/d7 ]; then
>                mkdir $DIR/d7
>        fi
>        $MCREATE $DIR/d7/f2
>        echo -n foo > $DIR/d7/f2
>        [ "`cat $DIR/d7/f2`"" "foo" ] || error
>        $CHECKSTAT -t file -s 3 $DIR/d7/f2 || error
> }
> run_test 7b "mkdir .../d7; mcreate d7/f2; echo foo > d7/f2"
>
> test_8() {
>        mkdir $DIR/d8
>        touch $DIR/d8/f
>        chmod 0666 $DIR/d8/f
>        $CHECKSTAT -t file -p 0666 $DIR/d8/f || error
> }
> run_test 8 "mkdir .../d8; touch .../d8/f; chmod .../d8/f"
>
> test_9() {
>        mkdir $DIR/d9
>        mkdir $DIR/d9/d2
>        mkdir $DIR/d9/d2/d3
>        $CHECKSTAT -t dir $DIR/d9/d2/d3 || error
> }
> run_test 9 "mkdir .../d9 .../d9/d2 .../d9/d2/d3"
>
> test_10() {
>        mkdir $DIR/d10
>        mkdir $DIR/d10/d2
>        touch $DIR/d10/d2/f
>        $CHECKSTAT -t file $DIR/d10/d2/f || error
> }
> run_test 10 "mkdir .../d10 .../d10/d2; touch .../d10/d2/f"
>
> test_11() {
>        mkdir $DIR/d11
>        mkdir $DIR/d11/d2
>        chmod 0666 $DIR/d11/d2
>        chmod 0705 $DIR/d11/d2
>        $CHECKSTAT -t dir -p 0705 $DIR/d11/d2 || error
> }
> run_test 11 "mkdir .../d11 d11/d2; chmod .../d11/d2"
>
> test_12() {
>        mkdir $DIR/d12
>        touch $DIR/d12/f
>        chmod 0666 $DIR/d12/f
>        chmod 0654 $DIR/d12/f
>        $CHECKSTAT -t file -p 0654 $DIR/d12/f || error
> }
> run_test 12 "touch .../d12/f; chmod .../d12/f .../d12/f"
>
> test_13() {
>        mkdir $DIR/d13
>        dd if=3D/dev/zero of=3D$DIR/d13/f count=3D10
>        >  $DIR/d13/f
>        $CHECKSTAT -t file -s 0 $DIR/d13/f || error
> }
> run_test 13 "creat .../d13/f; dd .../d13/f; > .../d13/f"
>
> test_14() {
>        mkdir $DIR/d14
>        touch $DIR/d14/f
>        rm $DIR/d14/f
>        $CHECKSTAT -a $DIR/d14/f || error
> }
> run_test 14 "touch .../d14/f; rm .../d14/f; rm .../d14/f"
>
> test_15() {
>        mkdir $DIR/d15
>        touch $DIR/d15/f
>        mv $DIR/d15/f $DIR/d15/f2
>        $CHECKSTAT -t file $DIR/d15/f2 || error
> }
> run_test 15 "touch .../d15/f; mv .../d15/f .../d15/f2"
>
> test_16() {
>        mkdir $DIR/d16
>        touch $DIR/d16/f
>        rm -rf $DIR/d16/f
>        $CHECKSTAT -a $DIR/d16/f || error
> }
> run_test 16 "touch .../d16/f; rm -rf .../d16/f"
>
> test_17a() {
>        mkdir -p $DIR/d17
>        touch $DIR/d17/f
>        ln -s $DIR/d17/f $DIR/d17/l-exist
>        ls -l $DIR/d17
>        $CHECKSTAT -l $DIR/d17/f $DIR/d17/l-exist || error
>        $CHECKSTAT -f -t f $DIR/d17/l-exist || error
>        rm -f $DIR/d17/l-exist
>        $CHECKSTAT -a $DIR/d17/l-exist || error
> }
> run_test 17a "symlinks: create, remove (real)"
>
> test_17b() {
>        mkdir -p $DIR/d17
>        ln -s no-such-file $DIR/d17/l-dangle
>        ls -l $DIR/d17
>        $CHECKSTAT -l no-such-file $DIR/d17/l-dangle || error
>        $CHECKSTAT -fa $DIR/d17/l-dangle || error
>        rm -f $DIR/d17/l-dangle
>        $CHECKSTAT -a $DIR/d17/l-dangle || error
> }
> run_test 17b "symlinks: create, remove (dangling)"
>
> test_17c() { # bug 3440 - don't save failed open RPC for replay
>        mkdir -p $DIR/d17
>        ln -s foo $DIR/d17/f17c
>        cat $DIR/d17/f17c && error "opened non-existent symlink" || true
> }
> run_test 17c "symlinks: open dangling (should return error)""
>
> test_17d() {
>        mkdir -p $DIR/d17
>        ln -s foo $DIR/d17/f17d
>        touch $DIR/d17/f17d || error "creating to new symlink"
> }
> run_test 17d "symlinks: create dangling"
>
> test_17e() {
>        mkdir -p $DIR/$tdir
>        local foo=3D$DIR/$tdir/$tfile
>        ln -s $foo $foo || error "create symlink failed"
>        ls -l $foo || error "ls -l failed"
>        ls $foo && error "ls not failed" || true
> }
> run_test 17e "symlinks: create recursive symlink (should return error)""
>
> test_17f() {
>        mkdir -p $DIR/d17f
>        ln -s 1234567890/2234567890/3234567890/4234567890 $DIR/d17f/111
>        ln -s
> 1234567890/2234567890/3234567890/4234567890/5234567890/6234567890
> $DIR/d17f/222
>        ln -s
> 1234567890/2234567890/3234567890/4234567890/5234567890/6234567890/7234567=
890/8234567890
> $DIR/d17f/333
>        ln -s
> 1234567890/2234567890/3234567890/4234567890/5234567890/6234567890/7234567=
890/8234567890/9234567890/a234567890/b234567890
> $DIR/d17f/444
>        ln -s
> 1234567890/2234567890/3234567890/4234567890/5234567890/6234567890/7234567=
890/8234567890/9234567890/a234567890/b234567890/c234567890/d234567890/f2345=
67890
> $DIR/d17f/555
>        ln -s
> 1234567890/2234567890/3234567890/4234567890/5234567890/6234567890/7234567=
890/8234567890/9234567890/a234567890/b234567890/c234567890/d234567890/f2345=
67890/aaaaaaaaaa/bbbbbbbbbb/cccccccccc/dddddddddd/eeeeeeeeee/ffffffffff/
> $DIR/d17f/666
>        ls -l  $DIR/d17f
> }
> run_test 17f "symlinks: long and very long symlink name"
>
> test_17g() {
>        mkdir -p $DIR/$tdir
>        LONGSYMLINK=3D"$(dd if=3D/dev/zero bs=3D4095 count=3D1 | tr '\0' '=
x')"
>        ln -s $LONGSYMLINK $DIR/$tdir/$tfile
>        ls -l $DIR/$tdir
> }
> run_test 17g "symlinks: really long symlink name"
>
> test_17h() { #bug 17378
>        mkdir -p $DIR/$tdir
>        $SETSTRIPE $DIR/$tdir -c -1
> #define OBD_FAIL_MDS_LOV_PREP_CREATE 0x141
>        do_facet mds lctl set_param fail_loc=3D0x80000141
>        touch $DIR/$tdir/$tfile || true
> }
> run_test 17h "create objects: lov_free_memmd() doesn't lbug"
>
> test_18() {
>        touch $DIR/f
>        ls $DIR || error
> }
> run_test 18 "touch .../f ; ls ..."
>
> test_19a() {
>        touch $DIR/f19
>        ls -l $DIR
>        rm $DIR/f19
>        $CHECKSTAT -a $DIR/f19 || error
> }
> run_test 19a "touch .../f19 ; ls -l ... ; rm .../f19"
>
> test_19b() {
>        ls -l $DIR/f19 && error || true
> }
> run_test 19b "ls -l .../f19 (should return error)"
>
> test_19c() {
>        [ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID =3D $UID -- skipping=
" &&
> return
>        $RUNAS touch $DIR/f19 && error || true
> }
> run_test 19c "$RUNAS touch .../f19 (should return error)""
>
> test_19d() {
>        cat $DIR/f19 && error || true
> }
> run_test 19d "cat .../f19 (should return error)"
>
> test_20() {
>        touch $DIR/f
>        rm $DIR/f
>        log "1 done"
>        touch $DIR/f
>        rm $DIR/f
>        log "2 done"
>        touch $DIR/f
>        rm $DIR/f
>        log "3 done"
>        $CHECKSTAT -a $DIR/f || error
> }
> run_test 20 "touch .../f ; ls -l ..."
>
> test_21() {
>        mkdir $DIR/d21
>        [ -f $DIR/d21/dangle ] && rm -f $DIR/d21/dangle
>        ln -s dangle $DIR/d21/link
>        echo foo >> $DIR/d21/link
>        cat $DIR/d21/dangle
>        $CHECKSTAT -t link $DIR/d21/link || error
>        $CHECKSTAT -f -t file $DIR/d21/link || error
> }
> run_test 21 "write to dangling link"
>
> test_22() {
>        WDIR=3D$DIR/$tdir
>        mkdir -p $WDIR
>        chown $RUNAS_ID $WDIR
>        (cd $WDIR || error "cd $WDIR failed";
>        $RUNAS tar cf - /etc/hosts /etc/sysconfig/network | \
>        $RUNAS tar xf -)
>        ls -lR $WDIR/etc || error "ls -lR $WDIR/etc failed"
>        $CHECKSTAT -t dir $WDIR/etc || error "checkstat -t dir failed"
>        $CHECKSTAT -u \#$RUNAS_ID $WDIR/etc || error "checkstat -u failed"
> }
> run_test 22 "unpack tar archive as non-root user"
>
> test_23() {
>        mkdir -p $DIR/$tdir
>        local file=3D$DIR/$tdir/$tfile
>
>        openfile -f O_CREAT:O_EXCL $file || error "$file create failed"
>        openfile -f O_CREAT:O_EXCL $file &&
>                error "$file recreate succeeded" || true
> }
> run_test 23 "O_CREAT|O_EXCL in subdir"
>
> test_24a() {
>        echo '=3D=3D rename sanity"
>        echo '-- same directory rename'
>        mkdir $DIR/R1
>        touch $DIR/R1/f
>        mv $DIR/R1/f $DIR/R1/g
>        $CHECKSTAT -t file $DIR/R1/g || error
> }
> run_test 24a "touch .../R1/f; rename .../R1/f .../R1/g"
>
> test_24b() {
>        mkdir $DIR/R2
>        touch $DIR/R2/{f,g}
>        mv $DIR/R2/f $DIR/R2/g
>        $CHECKSTAT -a $DIR/R2/f || error
>        $CHECKSTAT -t file $DIR/R2/g || error
> }
> run_test 24b "touch .../R2/{f,g}; rename .../R2/f .../R2/g"
>
> test_24c() {
>        mkdir $DIR/R3
>        mkdir $DIR/R3/f
>        mv $DIR/R3/f $DIR/R3/g
>        $CHECKSTAT -a $DIR/R3/f || error
>        $CHECKSTAT -t dir $DIR/R3/g || error
> }
> run_test 24c "mkdir .../R3/f; rename .../R3/f .../R3/g"
>
> test_24d() {
>        mkdir $DIR/R4
>        mkdir $DIR/R4/{f,g}
>        mrename $DIR/R4/f $DIR/R4/g
>        $CHECKSTAT -a $DIR/R4/f || error
>        $CHECKSTAT -t dir $DIR/R4/g || error
> }
> run_test 24d "mkdir .../R4/{f,g}; rename .../R4/f .../R4/g"
>
> test_24e() {
>        echo '-- cross directory renames --'
>        mkdir $DIR/R5{a,b}
>        touch $DIR/R5a/f
>        mv $DIR/R5a/f $DIR/R5b/g
>        $CHECKSTAT -a $DIR/R5a/f || error
>        $CHECKSTAT -t file $DIR/R5b/g || error
> }
> run_test 24e "touch .../R5a/f; rename .../R5a/f .../R5b/g"
>
> test_24f() {
>        mkdir $DIR/R6{a,b}
>        touch $DIR/R6a/f $DIR/R6b/g
>        mv $DIR/R6a/f $DIR/R6b/g
>        $CHECKSTAT -a $DIR/R6a/f || error
>        $CHECKSTAT -t file $DIR/R6b/g || error
> }
> run_test 24f "touch .../R6a/f R6b/g; mv .../R6a/f .../R6b/g""
>
> test_24g() {
>        mkdir $DIR/R7{a,b}
>        mkdir $DIR/R7a/d
>        mv $DIR/R7a/d $DIR/R7b/e
>        $CHECKSTAT -a $DIR/R7a/d || error
>        $CHECKSTAT -t dir $DIR/R7b/e || error
> }
> run_test 24g "mkdir .../R7{a,b}/d; mv .../R7a/d .../R7b/e"
>
> test_24h() {
>        mkdir $DIR/R8{a,b}
>        mkdir $DIR/R8a/d $DIR/R8b/e
>        mrename $DIR/R8a/d $DIR/R8b/e
>        $CHECKSTAT -a $DIR/R8a/d || error
>        $CHECKSTAT -t dir $DIR/R8b/e || error
> }
> run_test 24h "mkdir .../R8{a,b}/{d,e}; rename .../R8a/d .../R8b/e"
>
> test_24i() {
>        echo "-- rename error cases"
>        mkdir $DIR/R9
>        mkdir $DIR/R9/a
>        touch $DIR/R9/f
>        mrename $DIR/R9/f $DIR/R9/a
>        $CHECKSTAT -t file $DIR/R9/f || error
>        $CHECKSTAT -t dir  $DIR/R9/a || error
>        $CHECKSTAT -a $DIR/R9/a/f || error
> }
> run_test 24i "rename file to dir error: touch f ; mkdir a ; rename f a"
>
> test_24j() {
>        mkdir $DIR/R10
>        mrename $DIR/R10/f $DIR/R10/g
>        $CHECKSTAT -t dir $DIR/R10 || error
>        $CHECKSTAT -a $DIR/R10/f || error
>        $CHECKSTAT -a $DIR/R10/g || error
> }
> run_test 24j "source does not exist"
>
> test_24k() {
>        mkdir $DIR/R11a $DIR/R11a/d
>        touch $DIR/R11a/f
>        mv $DIR/R11a/f $DIR/R11a/d
>        $CHECKSTAT -a $DIR/R11a/f || error
>        $CHECKSTAT -t file $DIR/R11a/d/f || error
> }
> run_test 24k "touch .../R11a/f; mv .../R11a/f .../R11a/d"
>
> # bug 2429 - rename foo foo foo creates invalid file
> test_24l() {
>        f=3D"$DIR/f24l"
>        multiop $f OcNs || error
> }
> run_test 24l "Renaming a file to itself"
>
> test_24m() {
>        f=3D"$DIR/f24m"
>        multiop $f OcLN ${f}2 ${f}2 || error "link ${f}2 ${f}2 failed"
>        # on ext3 this does not remove either the source or target files
>        # though the "expected" operation would be to remove the source
>        $CHECKSTAT -t file ${f} || error "${f} missing"
>        $CHECKSTAT -t file ${f}2 || error "${f}2 missing"
> }
> run_test 24m "Renaming a file to a hard link to itself"
>
> test_24n() {
>    f=3D"$DIR/f24n"
>    # this stats the old file after it was renamed, so it should fail
>    touch ${f}
>    $CHECKSTAT ${f}
>    mv ${f} ${f}.rename
>    $CHECKSTAT ${f}.rename
>    $CHECKSTAT -a ${f}
> }
> run_test 24n "Statting the old file after renaming (Posix rename 2)"
>
> test_24o() {
>        check_kernel_version 37 || return 0
>        mkdir -p $DIR/d24o
>        rename_many -s random -v -n 10 $DIR/d24o
> }
> run_test 24o "rename of files during htree split"
>
> test_24p() {
>        mkdir $DIR/R12{a,b}
>        DIRINO=3D`ls -lid $DIR/R12a | awk '{ print $1 }'`
>        mrename $DIR/R12a $DIR/R12b
>        $CHECKSTAT -a $DIR/R12a || error
>        $CHECKSTAT -t dir $DIR/R12b || error
>        DIRINO2=3D`ls -lid $DIR/R12b | awk '{ print $1 }'`
>        [ "$DIRINO"" "$DIRINO2" ] || error "R12a $DIRINO !=3D R12b $DIRINO=
2"
> }
> run_test 24p "mkdir .../R12{a,b}; rename .../R12a .../R12b"
>
> test_24q() {
>        mkdir $DIR/R13{a,b}
>        DIRINO=3D`ls -lid $DIR/R13a | awk '{ print $1 }'`
>        multiop_bg_pause $DIR/R13b D_c || return 1
>        MULTIPID=3D$!
>
>        mrename $DIR/R13a $DIR/R13b
>        $CHECKSTAT -a $DIR/R13a || error
>        $CHECKSTAT -t dir $DIR/R13b || error
>        DIRINO2=3D`ls -lid $DIR/R13b | awk '{ print $1 }'`
>        [ "$DIRINO"" "$DIRINO2" ] || error "R13a $DIRINO !=3D R13b $DIRINO=
2"
>        kill -USR1 $MULTIPID
>        wait $MULTIPID || error "multiop close failed"
> }
> run_test 24q "mkdir .../R13{a,b}; open R13b rename R13a R13b""
>
> test_24r() { #bug 3789
>        mkdir $DIR/R14a $DIR/R14a/b
>        mrename $DIR/R14a $DIR/R14a/b && error "rename to subdir worked!"
>        $CHECKSTAT -t dir $DIR/R14a || error "$DIR/R14a missing"
>        $CHECKSTAT -t dir $DIR/R14a/b || error "$DIR/R14a/b missing"
> }
> run_test 24r "mkdir .../R14a/b; rename .../R14a .../R14a/b"
>
> test_24s() {
>        mkdir $DIR/R15a $DIR/R15a/b $DIR/R15a/b/c
>        mrename $DIR/R15a $DIR/R15a/b/c && error "rename to sub-subdir
> worked!"
>        $CHECKSTAT -t dir $DIR/R15a || error "$DIR/R15a missing"
>        $CHECKSTAT -t dir $DIR/R15a/b/c || error "$DIR/R15a/b/c missing"
> }
> run_test 24s "mkdir .../R15a/b/c; rename .../R15a .../R15a/b/c""
> test_24t() {
>        mkdir $DIR/R16a $DIR/R16a/b $DIR/R16a/b/c
>        mrename $DIR/R16a/b/c $DIR/R16a && error "rename to sub-subdir
> worked!"
>        $CHECKSTAT -t dir $DIR/R16a || error "$DIR/R16a missing"
>        $CHECKSTAT -t dir $DIR/R16a/b/c || error "$DIR/R16a/b/c missing"
> }
> run_test 24t "mkdir .../R16a/b/c; rename .../R16a/b/c .../R16a""
>
> test_24u() { # bug12192
>        multiop $DIR/$tfile C2w$((2048 * 1024))c || error
>        $CHECKSTAT -s $((2048 * 1024)) $DIR/$tfile || error "wrong file
> size"
> }
> run_test 24u "create stripe file"
>
> test_25a() {
>        echo '=3D=3D symlink sanity"
>
>        mkdir $DIR/d25
>        ln -s d25 $DIR/s25
>        touch $DIR/s25/foo || error
> }
> run_test 25a "create file in symlinked directory"
>
> test_25b() {
>        [ ! -d $DIR/d25 ] && test_25a
>        $CHECKSTAT -t file $DIR/s25/foo || error
> }
> run_test 25b "lookup file in symlinked directory""
>
> test_26a() {
>        mkdir $DIR/d26
>        mkdir $DIR/d26/d26-2
>        ln -s d26/d26-2 $DIR/s26
>        touch $DIR/s26/foo || error
> }
> run_test 26a "multiple component symlink""
>
> test_26b() {
>        mkdir -p $DIR/d26b/d26-2
>        ln -s d26b/d26-2/foo $DIR/s26-2
>        touch $DIR/s26-2 || error
> }
> run_test 26b "multiple component symlink at end of lookup""
>
> test_26c() {
>        mkdir $DIR/d26.2
>        touch $DIR/d26.2/foo
>        ln -s d26.2 $DIR/s26.2-1
>        ln -s s26.2-1 $DIR/s26.2-2
>        ln -s s26.2-2 $DIR/s26.2-3
>        chmod 0666 $DIR/s26.2-3/foo
> }
> run_test 26c "chain of symlinks""
>
> # recursive symlinks (bug 439)
> test_26d() {
>        ln -s d26-3/foo $DIR/d26-3
> }
> run_test 26d "create multiple component recursive symlink""
>
> test_26e() {
>        [ ! -h $DIR/d26-3 ] && test_26d
>        rm $DIR/d26-3
> }
> run_test 26e "unlink multiple component recursive symlink""
>
> # recursive symlinks (bug 7022)
> test_26f() {
>        mkdir -p $DIR/$tdir
>        mkdir $DIR/$tdir/$tfile        || error "mkdir $DIR/$tdir/$tfile
> failed"
>        cd $DIR/$tdir/$tfile           || error "cd $DIR/$tdir/$tfile
> failed"
>        mkdir -p lndir/bar1      || error "mkdir lndir/bar1 failed"
>        mkdir $tfile             || error "mkdir $tfile failed"
>        cd $tfile                || error "cd $tfile failed"
>        ln -s .. dotdot          || error "ln dotdot failed"
>        ln -s dotdot/lndir lndir || error "ln lndir failed"
>        cd $DIR/$tdir                 || error "cd $DIR/$tdir failed"
>        output=3D`ls $tfile/$tfile/lndir/bar1`
>        [ "$output"" bar1 ] && error "unexpected output"
>        rm -r $tfile             || error "rm $tfile failed"
>        $CHECKSTAT -a $DIR/$tfile || error "$tfile not gone"
> }
> run_test 26f "rm -r of a directory which has recursive symlink""
>
> # createtest also checks that device nodes are created and
> # then visible correctly (#2091)
> test_28() { # bug 2091
>        mkdir $DIR/d28
>        $CREATETEST $DIR/d28/ct || error
> }
> run_test 28 "create/mknod/mkdir with bad file types""
>
> test_30() {
>        cp `which ls` $DIR || cp /bin/ls $DIR
>        $DIR/ls /
>        rm $DIR/ls
> }
> run_test 30 "run binary from Lustre (execve)""
>
> test_31a() {
>        $OPENUNLINK $DIR/f31 $DIR/f31 || error
>        $CHECKSTAT -a $DIR/f31 || error
> }
> run_test 31a "open-unlink file""
>
> test_31b() {
>        touch $DIR/f31 || error
>        ln $DIR/f31 $DIR/f31b || error
>        multiop $DIR/f31b Ouc || error
>        $CHECKSTAT -t file $DIR/f31 || error
> }
> run_test 31b "unlink file with multiple links while open""
>
> test_31c() {
>        touch $DIR/f31 || error
>        ln $DIR/f31 $DIR/f31c || error
>        multiop_bg_pause $DIR/f31 O_uc || return 1
>        MULTIPID=3D$!
>        multiop $DIR/f31c Ouc
>        kill -USR1 $MULTIPID
>        wait $MULTIPID
> }
> run_test 31c "open-unlink file with multiple links""
>
> test_31d() {
>        opendirunlink $DIR/d31d $DIR/d31d || error
>        $CHECKSTAT -a $DIR/d31d || error
> }
> run_test 31d "remove of open directory""
>
> test_31e() { # bug 2904
>        check_kernel_version 34 || return 0
>        openfilleddirunlink $DIR/d31e || error
> }
> run_test 31e "remove of open non-empty directory""
>
> test_31f() { # bug 4554
>        set -vx
>        mkdir $DIR/d31f
>        $SETSTRIPE $DIR/d31f -s 1048576 -c 1
>        cp /etc/hosts $DIR/d31f
>        ls -l $DIR/d31f
>        multiop_bg_pause $DIR/d31f D_c || return 1
>        MULTIPID=3D$!
>
>        rm -rv $DIR/d31f || error "first of $DIR/d31f"
>        mkdir $DIR/d31f
>        $SETSTRIPE $DIR/d31f -s 1048576 -c 1
>        cp /etc/hosts $DIR/d31f
>        ls -l $DIR/d31f
>        $DIR/d31f/hosts
>        multiop_bg_pause $DIR/d31f D_c || return 1
>        MULTIPID2=3D$!
>
>        kill -USR1 $MULTIPID || error "first opendir $MULTIPID not running=
"
>        wait $MULTIPID || error "first opendir $MULTIPID failed"
>
>        sleep 6
>
>        kill -USR1 $MULTIPID2 || error "second opendir $MULTIPID not
> running"
>        wait $MULTIPID2 || error "second opendir $MULTIPID2 failed"
>        set +vx
> }
> run_test 31f "remove of open directory with open-unlink file""
>
> test_31g() {
>        echo "-- cross directory link --"
>        mkdir $DIR/d31g{a,b}
>        touch $DIR/d31ga/f
>        ln $DIR/d31ga/f $DIR/d31gb/g
>        $CHECKSTAT -t file $DIR/d31ga/f || error "source"
>        [ `stat -c%h $DIR/d31ga/f`" '2' ] || error "source nlink"
>        $CHECKSTAT -t file $DIR/d31gb/g || error "target"
>        [ `stat -c%h $DIR/d31gb/g`" '2' ] || error "target nlink"
> }
> run_test 31g "cross directory link=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D"
>
> test_31h() {
>        echo "-- cross directory link --"
>        mkdir $DIR/d31h
>        mkdir $DIR/d31h/dir
>        touch $DIR/d31h/f
>        ln $DIR/d31h/f $DIR/d31h/dir/g
>        $CHECKSTAT -t file $DIR/d31h/f || error "source"
>        [ `stat -c%h $DIR/d31h/f`" '2' ] || error "source nlink"
>        $CHECKSTAT -t file $DIR/d31h/dir/g || error "target"
>        [ `stat -c%h $DIR/d31h/dir/g`" '2' ] || error "target nlink"
> }
> run_test 31h "cross directory link under child=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D"
>
> test_31i() {
>        echo "-- cross directory link --"
>        mkdir $DIR/d31i
>        mkdir $DIR/d31i/dir
>        touch $DIR/d31i/dir/f
>        ln $DIR/d31i/dir/f $DIR/d31i/g
>        $CHECKSTAT -t file $DIR/d31i/dir/f || error "source"
>        [ `stat -c%h $DIR/d31i/dir/f`" '2' ] || error "source nlink"
>        $CHECKSTAT -t file $DIR/d31i/g || error "target"
>        [ `stat -c%h $DIR/d31i/g`" '2' ] || error "target nlink"
> }
> run_test 31i "cross directory link under parent=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D"
>
>
> test_31j() {
>        mkdir $DIR/d31j
>        mkdir $DIR/d31j/dir1
>        ln $DIR/d31j/dir1 $DIR/d31j/dir2 && error "ln for dir"
>        link $DIR/d31j/dir1 $DIR/d31j/dir3 && error "link for dir"
>        mlink $DIR/d31j/dir1 $DIR/d31j/dir4 && error "mlink for dir"
>        mlink $DIR/d31j/dir1 $DIR/d31j/dir1 && error "mlink to the same di=
r"
>        return 0
> }
> run_test 31j "link for directory=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D"
>
>
> test_31k() {
>        mkdir $DIR/d31k
>        touch $DIR/d31k/s
>        touch $DIR/d31k/exist
>        mlink $DIR/d31k/s $DIR/d31k/t || error "mlink"
>        mlink $DIR/d31k/s $DIR/d31k/exist && error "mlink to exist file"
>        mlink $DIR/d31k/s $DIR/d31k/s && error "mlink to the same file"
>        mlink $DIR/d31k/s $DIR/d31k && error "mlink to parent dir"
>        mlink $DIR/d31k $DIR/d31k/s && error "mlink parent dir to target"
>        mlink $DIR/d31k/not-exist $DIR/d31k/foo && error "mlink non-existi=
ng
> to new"
>        mlink $DIR/d31k/not-exist $DIR/d31k/s && error "mlink non-existing
> to exist"
>        return 0
> }
> run_test 31k "link to file: the same, non-existing, dir=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D"
>
> test_31m() {
>        mkdir $DIR/d31m
>        touch $DIR/d31m/s
>        mkdir $DIR/d31m2
>        touch $DIR/d31m2/exist
>        mlink $DIR/d31m/s $DIR/d31m2/t || error "mlink"
>        mlink $DIR/d31m/s $DIR/d31m2/exist && error "mlink to exist file"
>        mlink $DIR/d31m/s $DIR/d31m2 && error "mlink to parent dir"
>        mlink $DIR/d31m2 $DIR/d31m/s && error "mlink parent dir to target"
>        mlink $DIR/d31m/not-exist $DIR/d31m2/foo && error "mlink
> non-existing to new"
>        mlink $DIR/d31m/not-exist $DIR/d31m2/s && error "mlink non-existin=
g
> to exist"
>        return 0
> }
> run_test 31m "link to file: the same, non-existing, dir=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D"
>
> test_32a() {
>        echo "=3D=3D more mountpoints and symlinks""
>        [ -e $DIR/d32a ] && rm -fr $DIR/d32a
>        mkdir -p $DIR/d32a/ext2-mountpoint
>        mount -t ext2 -o loop $EXT2_DEV $DIR/d32a/ext2-mountpoint || error
>        $CHECKSTAT -t dir $DIR/d32a/ext2-mountpoint/.. || error
>        $UMOUNT $DIR/d32a/ext2-mountpoint || error
> }
> run_test 32a "stat d32a/ext2-mountpoint/..""
>
> test_32b() {
>        [ -e $DIR/d32b ] && rm -fr $DIR/d32b
>        mkdir -p $DIR/d32b/ext2-mountpoint
>        mount -t ext2 -o loop $EXT2_DEV $DIR/d32b/ext2-mountpoint || error
>        ls -al $DIR/d32b/ext2-mountpoint/.. || error
>        $UMOUNT $DIR/d32b/ext2-mountpoint || error
> }
> run_test 32b "open d32b/ext2-mountpoint/..""
>
> test_32c() {
>        [ -e $DIR/d32c ] && rm -fr $DIR/d32c
>        mkdir -p $DIR/d32c/ext2-mountpoint
>        mount -t ext2 -o loop $EXT2_DEV $DIR/d32c/ext2-mountpoint || error
>        mkdir -p $DIR/d32c/d2/test_dir
>        $CHECKSTAT -t dir $DIR/d32c/ext2-mountpoint/../d2/test_dir || erro=
r
>        $UMOUNT $DIR/d32c/ext2-mountpoint || error
> }
> run_test 32c "stat d32c/ext2-mountpoint/../d2/test_dir""
>
> test_32d() {
>        [ -e $DIR/d32d ] && rm -fr $DIR/d32d
>        mkdir -p $DIR/d32d/ext2-mountpoint
>        mount -t ext2 -o loop $EXT2_DEV $DIR/d32d/ext2-mountpoint || error
>        mkdir -p $DIR/d32d/d2/test_dir
>        ls -al $DIR/d32d/ext2-mountpoint/../d2/test_dir || error
>        $UMOUNT $DIR/d32d/ext2-mountpoint || error
> }
> run_test 32d "open d32d/ext2-mountpoint/../d2/test_dir""
>
> test_32e() {
>        [ -e $DIR/d32e ] && rm -fr $DIR/d32e
>        mkdir -p $DIR/d32e/tmp
>        TMP_DIR=3D$DIR/d32e/tmp
>        ln -s $DIR/d32e $TMP_DIR/symlink11
>        ln -s $TMP_DIR/symlink11 $TMP_DIR/../symlink01
>        $CHECKSTAT -t link $DIR/d32e/tmp/symlink11 || error
>        $CHECKSTAT -t link $DIR/d32e/symlink01 || error
> }
> run_test 32e "stat d32e/symlink->tmp/symlink->lustre-subdir""
>
> test_32f() {
>        [ -e $DIR/d32f ] && rm -fr $DIR/d32f
>        mkdir -p $DIR/d32f/tmp
>        TMP_DIR=3D$DIR/d32f/tmp
>        ln -s $DIR/d32f $TMP_DIR/symlink11
>        ln -s $TMP_DIR/symlink11 $TMP_DIR/../symlink01
>        ls $DIR/d32f/tmp/symlink11  || error
>        ls $DIR/d32f/symlink01 || error
> }
> run_test 32f "open d32f/symlink->tmp/symlink->lustre-subdir""
>
> test_32g() {
>        TMP_DIR=3D$DIR/$tdir/tmp
>        mkdir -p $TMP_DIR $DIR/${tdir}2
>        ln -s $DIR/${tdir}2 $TMP_DIR/symlink12
>        ln -s $TMP_DIR/symlink12 $TMP_DIR/../symlink02
>        $CHECKSTAT -t link $TMP_DIR/symlink12 || error
>        $CHECKSTAT -t link $DIR/$tdir/symlink02 || error
>        $CHECKSTAT -t dir -f $TMP_DIR/symlink12 || error
>        $CHECKSTAT -t dir -f $DIR/$tdir/symlink02 || error
> }
> run_test 32g "stat d32g/symlink->tmp/symlink->lustre-subdir/${tdir}2"
>
> test_32h() {
>        rm -fr $DIR/$tdir $DIR/${tdir}2
>        TMP_DIR=3D$DIR/$tdir/tmp
>        mkdir -p $TMP_DIR $DIR/${tdir}2
>        ln -s $DIR/${tdir}2 $TMP_DIR/symlink12
>        ln -s $TMP_DIR/symlink12 $TMP_DIR/../symlink02
>        ls $TMP_DIR/symlink12 || error
>        ls $DIR/$tdir/symlink02  || error
> }
> run_test 32h "open d32h/symlink->tmp/symlink->lustre-subdir/${tdir}2"
>
> test_32i() {
>        [ -e $DIR/d32i ] && rm -fr $DIR/d32i
>        mkdir -p $DIR/d32i/ext2-mountpoint
>        mount -t ext2 -o loop $EXT2_DEV $DIR/d32i/ext2-mountpoint || error
>        touch $DIR/d32i/test_file
>        $CHECKSTAT -t file $DIR/d32i/ext2-mountpoint/../test_file || error
>        $UMOUNT $DIR/d32i/ext2-mountpoint || error
> }
> run_test 32i "stat d32i/ext2-mountpoint/../test_file""
>
> test_32j() {
>        [ -e $DIR/d32j ] && rm -fr $DIR/d32j
>        mkdir -p $DIR/d32j/ext2-mountpoint
>        mount -t ext2 -o loop $EXT2_DEV $DIR/d32j/ext2-mountpoint || error
>        touch $DIR/d32j/test_file
>        cat $DIR/d32j/ext2-mountpoint/../test_file || error
>        $UMOUNT $DIR/d32j/ext2-mountpoint || error
> }
> run_test 32j "open d32j/ext2-mountpoint/../test_file""
>
> test_32k() {
>        rm -fr $DIR/d32k
>        mkdir -p $DIR/d32k/ext2-mountpoint
>        mount -t ext2 -o loop $EXT2_DEV $DIR/d32k/ext2-mountpoint
>        mkdir -p $DIR/d32k/d2
>        touch $DIR/d32k/d2/test_file || error
>        $CHECKSTAT -t file $DIR/d32k/ext2-mountpoint/../d2/test_file ||
> error
>        $UMOUNT $DIR/d32k/ext2-mountpoint || error
> }
> run_test 32k "stat d32k/ext2-mountpoint/../d2/test_file""
>
> test_32l() {
>        rm -fr $DIR/d32l
>        mkdir -p $DIR/d32l/ext2-mountpoint
>        mount -t ext2 -o loop $EXT2_DEV $DIR/d32l/ext2-mountpoint || error
>        mkdir -p $DIR/d32l/d2
>        touch $DIR/d32l/d2/test_file
>        cat  $DIR/d32l/ext2-mountpoint/../d2/test_file || error
>        $UMOUNT $DIR/d32l/ext2-mountpoint || error
> }
> run_test 32l "open d32l/ext2-mountpoint/../d2/test_file""
>
> test_32m() {
>        rm -fr $DIR/d32m
>        mkdir -p $DIR/d32m/tmp
>        TMP_DIR=3D$DIR/d32m/tmp
>        ln -s $DIR $TMP_DIR/symlink11
>        ln -s $TMP_DIR/symlink11 $TMP_DIR/../symlink01
>        $CHECKSTAT -t link $DIR/d32m/tmp/symlink11 || error
>        $CHECKSTAT -t link $DIR/d32m/symlink01 || error
> }
> run_test 32m "stat d32m/symlink->tmp/symlink->lustre-root""
>
> test_32n() {
>        rm -fr $DIR/d32n
>        mkdir -p $DIR/d32n/tmp
>        TMP_DIR=3D$DIR/d32n/tmp
>        ln -s $DIR $TMP_DIR/symlink11
>        ln -s $TMP_DIR/symlink11 $TMP_DIR/../symlink01
>        ls -l $DIR/d32n/tmp/symlink11  || error
>        ls -l $DIR/d32n/symlink01 || error
> }
> run_test 32n "open d32n/symlink->tmp/symlink->lustre-root""
>
> test_32o() {
>        rm -fr $DIR/d32o $DIR/$tfile
>        touch $DIR/$tfile
>        mkdir -p $DIR/d32o/tmp
>        TMP_DIR=3D$DIR/d32o/tmp
>        ln -s $DIR/$tfile $TMP_DIR/symlink12
>        ln -s $TMP_DIR/symlink12 $TMP_DIR/../symlink02
>        $CHECKSTAT -t link $DIR/d32o/tmp/symlink12 || error
>        $CHECKSTAT -t link $DIR/d32o/symlink02 || error
>        $CHECKSTAT -t file -f $DIR/d32o/tmp/symlink12 || error
>        $CHECKSTAT -t file -f $DIR/d32o/symlink02 || error
> }
> run_test 32o "stat d32o/symlink->tmp/symlink->lustre-root/$tfile"
>
> test_32p() {
>    log 32p_1
>        rm -fr $DIR/d32p
>    log 32p_2
>        rm -f $DIR/$tfile
>    log 32p_3
>        touch $DIR/$tfile
>    log 32p_4
>        mkdir -p $DIR/d32p/tmp
>    log 32p_5
>        TMP_DIR=3D$DIR/d32p/tmp
>    log 32p_6
>        ln -s $DIR/$tfile $TMP_DIR/symlink12
>    log 32p_7
>        ln -s $TMP_DIR/symlink12 $TMP_DIR/../symlink02
>    log 32p_8
>        cat $DIR/d32p/tmp/symlink12 || error
>    log 32p_9
>        cat $DIR/d32p/symlink02 || error
>    log 32p_10
> }
> run_test 32p "open d32p/symlink->tmp/symlink->lustre-root/$tfile"
>
> test_32q() {
>        [ -e $DIR/d32q ] && rm -fr $DIR/d32q
>        mkdir -p $DIR/d32q
>        touch $DIR/d32q/under_the_mount
>        mount -t ext2 -o loop $EXT2_DEV $DIR/d32q
>        ls $DIR/d32q/under_the_mount && error || true
>        $UMOUNT $DIR/d32q || error
> }
> run_test 32q "stat follows mountpoints in Lustre (should return error)"
>
> test_32r() {
>        [ -e $DIR/d32r ] && rm -fr $DIR/d32r
>        mkdir -p $DIR/d32r
>        touch $DIR/d32r/under_the_mount
>        mount -t ext2 -o loop $EXT2_DEV $DIR/d32r
>        ls $DIR/d32r | grep -q under_the_mount && error || true
>        $UMOUNT $DIR/d32r || error
> }
> run_test 32r "opendir follows mountpoints in Lustre (should return error)=
"
>
> test_33() {
>        rm -f $DIR/$tfile
>        touch $DIR/$tfile
>        chmod 444 $DIR/$tfile
>        chown $RUNAS_ID $DIR/$tfile
>        log 33_1
>        $RUNAS $OPENFILE -f O_RDWR $DIR/$tfile && error || true
>        log 33_2
> }
> run_test 33 "write file with mode 444 (should return error)""
>
> test_33a() {
>        rm -fr $DIR/d33
>        mkdir -p $DIR/d33
>        chown $RUNAS_ID $DIR/d33
>        $RUNAS $OPENFILE -f O_RDWR:O_CREAT -m 0444 $DIR/d33/f33|| error
> "create"
>        $RUNAS $OPENFILE -f O_RDWR:O_CREAT -m 0444 $DIR/d33/f33 && \
>                error "open RDWR" || true
> }
> run_test 33a "test open file(mode=3D0444) with O_RDWR (should return erro=
r)"
>
> test_33b() {
>        rm -fr $DIR/d33
>        mkdir -p $DIR/d33
>        chown $RUNAS_ID $DIR/d33
>        $RUNAS $OPENFILE -f 1286739555 $DIR/d33/f33 && error "create" ||
> true
> }
> run_test 33b "test open file with malformed flags (No panic and return
> error)"
>
> TEST_34_SIZE=3D${TEST_34_SIZE:-2000000000000}
> test_34a() {
>        rm -f $DIR/f34
>        $MCREATE $DIR/f34 || error
>        $TRUNCATE $DIR/f34 $TEST_34_SIZE || error
>        $CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error
> }
> run_test 34a "truncate file that has not been opened""
>
> test_34b() {
>        [ ! -f $DIR/f34 ] && test_34a
>        $CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error
>        $OPENFILE -f O_RDONLY $DIR/f34
>        $CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error
> }
> run_test 34b "O_RDONLY opening file doesn't create objects""
>
> test_34c() {
>        [ ! -f $DIR/f34 ] && test_34a
>        $CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error
>        $OPENFILE -f O_RDWR $DIR/f34
>        $CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error
> }
> run_test 34c "O_RDWR opening file-with-size works""
>
> test_34d() {
>        [ ! -f $DIR/f34 ] && test_34a
>        dd if=3D/dev/zero of=3D$DIR/f34 conv=3Dnotrunc bs=3D4k count=3D1 |=
| error
>        $CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error
>        rm $DIR/f34
> }
> run_test 34d "write to sparse file""
>
> test_34e() {
>        rm -f $DIR/f34e
>        $MCREATE $DIR/f34e || error
>        $TRUNCATE $DIR/f34e 1000 || error
>        $CHECKSTAT -s 1000 $DIR/f34e || error
>        $OPENFILE -f O_RDWR $DIR/f34e
>        $CHECKSTAT -s 1000 $DIR/f34e || error
> }
> run_test 34e "create objects, some with size and some without""
>
> test_34f() { # bug 6242, 6243
>        SIZE34F=3D48000
>        rm -f $DIR/f34f
>        $MCREATE $DIR/f34f || error
>        $TRUNCATE $DIR/f34f $SIZE34F || error "truncating $DIR/f3f to
> $SIZE34F"
>        dd if=3D$DIR/f34f of=3D$TMP/f34f
>        $CHECKSTAT -s $SIZE34F $TMP/f34f || error "$TMP/f34f not $SIZE34F
> bytes"
>        dd if=3D/dev/zero of=3D$TMP/f34fzero bs=3D$SIZE34F count=3D1
>        cmp $DIR/f34f $TMP/f34fzero || error "$DIR/f34f not all zero"
>        cmp $TMP/f34f $TMP/f34fzero || error "$TMP/f34f not all zero"
>        rm $TMP/f34f $TMP/f34fzero $DIR/f34f
> }
> run_test 34f "read from a file with no objects until EOF""
>
> test_35a() {
>        cp /bin/sh $DIR/f35a
>        chmod 444 $DIR/f35a
>        chown $RUNAS_ID $DIR/f35a
>        $RUNAS $DIR/f35a && error || true
>        rm $DIR/f35a
> }
> run_test 35a "exec file with mode 444 (should return and not leak)""
>
> test_36a() {
>        rm -f $DIR/f36
>        utime $DIR/f36 || error
> }
> run_test 36a "MDS utime check (mknod, utime)""
>
> test_36b() {
>        echo "" > $DIR/f36
>        utime $DIR/f36 || error
> }
> run_test 36b "OST utime check (open, utime)""
>
> test_36c() {
>        rm -f $DIR/d36/f36
>        mkdir $DIR/d36
>        chown $RUNAS_ID $DIR/d36
>        $RUNAS utime $DIR/d36/f36 || error
> }
> run_test 36c "non-root MDS utime check (mknod, utime)""
>
> test_36d() {
>        [ ! -d $DIR/d36 ] && test_36c
>        echo "" > $DIR/d36/f36
>        $RUNAS utime $DIR/d36/f36 || error
> }
> run_test 36d "non-root OST utime check (open, utime)""
>
> test_36e() {
>        [ $RUNAS_ID -eq $UID ] && skip "RUNAS_ID" UID =3D $UID -- skipping=
" &&
> return
>        mkdir -p $DIR/$tdir
>        touch $DIR/$tdir/$tfile
>        $RUNAS utime $DIR/$tdir/$tfile && \
>                error "utime worked, expected failure" || true
> }
> run_test 36e "utime on non-owned file (should return error)""
>
> test_37() {
>        mkdir -p $DIR/$tdir
>        echo f > $DIR/$tdir/fbugfile
>        mount -t ext2 -o loop $EXT2_DEV $DIR/$tdir
>        ls $DIR/$tdir | grep "\<fbugfile\>" && error
>        $UMOUNT $DIR/$tdir || error
>        rm -f $DIR/$tdir/fbugfile || error
> }
> run_test 37 "ls a mounted file system to check old content""
>
> test_38() {
>        local file=3D$DIR/$tfile
>        touch $file
>        openfile -f O_DIRECTORY $file
>        local RC=3D$?
>        local ENOTDIR=3D20
>        [ $RC -eq 0 ] && error "opened file $file with O_DIRECTORY" || tru=
e
>        [ $RC -eq $ENOTDIR ] || error "error $RC should be ENOTDIR
> ($ENOTDIR)"
> }
> run_test 38 "open a regular file with O_DIRECTORY should return -ENOTDIR"=
"
>
> test_39() {
>        touch $DIR/$tfile
>        touch $DIR/${tfile}2
> #       ls -l  $DIR/$tfile $DIR/${tfile}2
> #       ls -lu  $DIR/$tfile $DIR/${tfile}2
> #       ls -lc  $DIR/$tfile $DIR/${tfile}2
>        sleep 2
>        $OPENFILE -f O_CREAT:O_TRUNC:O_WRONLY $DIR/${tfile}2
>        if [ ! $DIR/${tfile}2 -nt $DIR/$tfile ]; then
>                echo "mtime"
>                ls -l  $DIR/$tfile $DIR/${tfile}2
>                echo "atime"
>                ls -lu  $DIR/$tfile $DIR/${tfile}2
>                echo "ctime"
>                ls -lc  $DIR/$tfile $DIR/${tfile}2
>                error "O_TRUNC didn't change timestamps"
>        fi
> }
> run_test 39 "mtime changed on create""
>
> test_40() {
>        dd if=3D/dev/zero of=3D$DIR/f40 bs=3D4096 count=3D1
>        $RUNAS $OPENFILE -f O_WRONLY:O_TRUNC $DIR/f40 && error
>        $CHECKSTAT -t file -s 4096 $DIR/f40 || error
> }
> run_test 40 "failed open(O_TRUNC) doesn't truncate""
>
> test_43() {
>        mkdir -p $DIR/$tdir
>        cp -p /bin/ls $DIR/$tdir/$tfile
>        multiop $DIR/$tdir/$tfile Ow_c &
>        pid=3D$!
>        # give multiop a chance to open
>        sleep 1
>
>        $DIR/$tdir/$tfile && error || true
>        kill -USR1 $pid
> }
> run_test 43 "execution of file opened for write should return -ETXTBSY"
>
> test_43a() {
>        mkdir -p $DIR/d43
>        cp -p `which multiop` $DIR/d43/multiop || cp -p multiop
> $DIR/d43/multiop
>        MULTIOP_PROG=3D$DIR/d43/multiop multiop_bg_pause $TMP/test43.junk =
O_c
> || return 1
>        MULTIOP_PID=3D$!
>        multiop $DIR/d43/multiop Oc && error "expected error, got success"
>        kill -USR1 $MULTIOP_PID || return 2
>        wait $MULTIOP_PID || return 3
>        rm $TMP/test43.junk
> }
> run_test 43a "open(RDWR) of file being executed should return -ETXTBSY"
>
> test_43b() {
>        mkdir -p $DIR/d43
>        cp -p `which multiop` $DIR/d43/multiop || cp -p multiop
> $DIR/d43/multiop
>        MULTIOP_PROG=3D$DIR/d43/multiop multiop_bg_pause $TMP/test43.junk =
O_c
> || return 1
>        MULTIOP_PID=3D$!
>        truncate $DIR/d43/multiop 0 && error "expected error, got success"
>        kill -USR1 $MULTIOP_PID || return 2
>        wait $MULTIOP_PID || return 3
>        rm $TMP/test43.junk
> }
> run_test 43b "truncate of file being executed should return -ETXTBSY"
>
> page_size() {
>        getconf PAGE_SIZE
> }
>
> test_48a() { # bug 2399
>        mkdir -p $DIR/d48a
>        cd $DIR/d48a
>        mv $DIR/d48a $DIR/d48.new || error "move directory failed"
>        mkdir $DIR/d48a || error "recreate directory failed"
>        touch foo || error "'touch foo' failed after recreating cwd"
>        mkdir bar || error "'mkdir foo' failed after recreating cwd"
>        touch .foo || error "'touch .foo' failed after recreating cwd"
>        mkdir .bar || error "'mkdir .foo' failed after recreating cwd"
>        ls . > /dev/null || error "'ls .' failed after recreating cwd"
>        ls .. > /dev/null || error "'ls ..' failed after removing cwd"
>        cd . || error "'cd .' failed after recreating cwd"
>        mkdir . && error "'mkdir .' worked after recreating cwd"
>        rmdir . && error "'rmdir .' worked after recreating cwd"
>        ln -s . baz || error "'ln -s .' failed after recreating cwd"
>        cd .. || error "'cd ..' failed after recreating cwd"
> }
> run_test 48a "Access renamed working dir (should return errors)=3D"
>
> test_48b() { # bug 2399
>        mkdir -p $DIR/d48b
>        cd $DIR/d48b
>        rmdir $DIR/d48b || error "remove cwd $DIR/d48b failed"
>        touch foo && error "'touch foo' worked after removing cwd"
>        mkdir foo && error "'mkdir foo' worked after removing cwd"
>        touch .foo && error "'touch .foo' worked after removing cwd"
>        mkdir .foo && error "'mkdir .foo' worked after removing cwd"
>        ls . > /dev/null && error "'ls .' worked after removing cwd"
>        ls .. > /dev/null || error "'ls ..' failed after removing cwd"
>        mkdir . && error "'mkdir .' worked after removing cwd"
>        rmdir . && error "'rmdir .' worked after removing cwd"
>        ln -s . foo && error "'ln -s .' worked after removing cwd"
>        cd .. || echo "'cd ..' failed after removing cwd `pwd`"  #bug 3517
> }
> run_test 48b "Access removed working dir (should return errors)=3D"
>
> test_48c() { # bug 2350
>        mkdir -p $DIR/d48c/dir
>        cd $DIR/d48c/dir
>        rmdir $DIR/d48c/dir || error "remove cwd $DIR/d48c/dir failed"
>        touch foo && error "'touch foo' worked after removing cwd"
>        mkdir foo && error "'mkdir foo' worked after removing cwd"
>        touch .foo && error "'touch .foo' worked after removing cwd"
>        mkdir .foo && error "'mkdir .foo' worked after removing cwd"
>        ls . && error "'ls .' worked after removing cwd"
>        ls .. || error "'ls ..' failed after removing cwd"
>        mkdir . && error "'mkdir .' worked after removing cwd"
>        rmdir . && error "'rmdir .' worked after removing cwd"
>        ln -s . foo && error "'ln -s .' worked after removing cwd"
>        cd .. || echo "'cd ..' failed after removing cwd `pwd`" #bug 3415
> }
> run_test 48c "Access removed working subdir (should return errors)"
>
> test_48d() { # bug 2350
>        mkdir -p $DIR/d48d/dir
>        cd $DIR/d48d/dir
>        rmdir $DIR/d48d/dir || error "remove cwd $DIR/d48d/dir failed"
>        rmdir $DIR/d48d || error "remove parent $DIR/d48d failed"
>        touch foo && error "'touch foo' worked after removing parent"
>        mkdir foo && error "'mkdir foo' worked after removing parent"
>        touch .foo && error "'touch .foo' worked after removing parent"
>        mkdir .foo && error "'mkdir .foo' worked after removing parent"
>        ls . && error "'ls .' worked after removing parent"
>        ls .. && error "'ls ..' worked after removing parent"
>        mkdir . && error "'mkdir .' worked after removing parent"
>        rmdir . && error "'rmdir .' worked after removing parent"
>        ln -s . foo && error "'ln -s .' worked after removing parent"
> }
> run_test 48d "Access removed parent subdir (should return errors)"
>
> test_48e() { # bug 4134
>        mkdir -p $DIR/d48e/dir
>        cd $DIR/d48e/dir
>        rmdir $DIR/d48e/dir || error "remove cwd $DIR/d48e/dir failed"
>        rmdir $DIR/d48e || error "remove parent $DIR/d48e failed"
>        touch $DIR/d48e || error "'touch $DIR/d48e' failed"
>        chmod +x $DIR/d48e || error "'chmod +x $DIR/d48e' failed"
>        # On a buggy kernel addition of "touch foo" after cd .. will
>        # produce kernel oops in lookup_hash_it
>        touch ../foo && error "'cd ..' worked after recreate parent"
>        cd $DIR
>        rm $DIR/d48e || error "rm '$DIR/d48e' failed"
> }
> run_test 48e "Access to recreated parent subdir (should return errors)"
>
> test_50() {
>        # bug 1485
>        mkdir $DIR/d50
>        cd $DIR/d50
>        ls /proc/$$/cwd || error
> }
> run_test 50 "special situations: /proc symlinks ""
>
> test_51a() {    # was test_51
>        # bug 1516 - create an empty entry right after ".." then split dir
>        mkdir $DIR/d51
>        touch $DIR/d51/foo
>        $MCREATE $DIR/d51/bar
>        rm $DIR/d51/foo
>        createmany -m $DIR/d51/longfile 201
>        FNUM=3D202
>        while [ `ls -sd $DIR/d51 | awk '{ print $1 }'` -eq 4 ]; do
>                $MCREATE $DIR/d51/longfile$FNUM
>                FNUM=3D$(($FNUM + 1))
>                echo -n "+"
>        done
>        echo
>        ls -l $DIR/d51 > /dev/null || error
> }
> run_test 51a "special situations: split htree with empty entry""
>
> export NUMTEST=3D70000
> test_51b() {
>        NUMFREE=3D`df -i -P $DIR | tail -n 1 | awk '{ print $4 }'`
>        [ $NUMFREE -lt 21000 ] && \
>                skip "not enough free inodes ($NUMFREE)" && \
>                return
>
>        check_kernel_version 40 || NUMTEST=3D31000
>        [ $NUMFREE -lt $NUMTEST ] && NUMTEST=3D$(($NUMFREE - 50))
>
>        mkdir -p $DIR/d51b
>        createmany -d $DIR/d51b/t- $NUMTEST
> }
> run_test 51b "mkdir .../t-0 --- .../t-$NUMTEST""
>
> test_51c() {
>        [ ! -d $DIR/d51b ] && skip "$DIR/51b missing" && \
>                return
>
>        unlinkmany -d $DIR/d51b/t- $NUMTEST
> }
> run_test 51c "rmdir .../t-0 --- .../t-$NUMTEST""
>
> test_52a() {
>        [ -f $DIR/d52a/foo ] && chattr -a $DIR/d52a/foo
>        mkdir -p $DIR/d52a
>        touch $DIR/d52a/foo
>        chattr"a $DIR/d52a/foo || error "chattr =3Da failed"
>        echo bar >> $DIR/d52a/foo || error "append bar failed"
>        cp /etc/hosts $DIR/d52a/foo && error "cp worked"
>        rm -f $DIR/d52a/foo 2>/dev/null && error "rm worked"
>        link $DIR/d52a/foo $DIR/d52a/foo_link 2>/dev/null && error "link
> worked"
>        echo foo >> $DIR/d52a/foo || error "append foo failed"
>        mrename $DIR/d52a/foo $DIR/d52a/foo_ren && error "rename worked"
>        lsattr $DIR/d52a/foo | egrep -q "^-+a-+ $DIR/d52a/foo" || error
> "lsattr"
>        chattr -a $DIR/d52a/foo || error "chattr -a failed"
>
>        rm -fr $DIR/d52a || error "cleanup rm failed"
> }
> run_test 52a "append-only flag test (should return errors)""
>
> test_52b() {
>        [ -f $DIR/d52b/foo ] && chattr -i $DIR/d52b/foo
>        mkdir -p $DIR/d52b
>        touch $DIR/d52b/foo
>        chattr"i $DIR/d52b/foo || error
>        cat test > $DIR/d52b/foo && error
>        cp /etc/hosts $DIR/d52b/foo && error
>        rm -f $DIR/d52b/foo 2>/dev/null && error
>        link $DIR/d52b/foo $DIR/d52b/foo_link 2>/dev/null && error
>        echo foo >> $DIR/d52b/foo && error
>        mrename $DIR/d52b/foo $DIR/d52b/foo_ren && error
>        [ -f $DIR/d52b/foo ] || error
>        [ -f $DIR/d52b/foo_ren ] && error
>        lsattr $DIR/d52b/foo | egrep -q "^-+i-+ $DIR/d52b/foo" || error
>        chattr -i $DIR/d52b/foo || error
>
>        rm -fr $DIR/d52b || error
> }
> run_test 52b "immutable flag test (should return errors)""
>
> test_54b() {
>        f=3D"$DIR/f54b"
>        mknod $f c 1 3
>        chmod 0666 $f
>        dd if=3D/dev/zero of=3D$f bs=3D`page_size` count=3D1
> }
> run_test 54b "char device works in lustre""
>
> find_loop_dev() {
>        [ -b /dev/loop/0 ] && LOOPBASE=3D/dev/loop/
>        [ -b /dev/loop0 ] && LOOPBASE=3D/dev/loop
>        [ -z "$LOOPBASE" ] && echo "/dev/loop/0 and /dev/loop0 gone?" &&
> return
>
>        for i in `seq 3 7`; do
>                losetup $LOOPBASE$i > /dev/null 2>&1 && continue
>                LOOPDEV=3D$LOOPBASE$i
>                LOOPNUM=3D$i
>                break
>        done
> }
>
> test_54c() {
>        tfile=3D"$DIR/f54c"
>        tdir=3D"$DIR/d54c"
>        loopdev=3D"$DIR/loop54c"
>
>        find_loop_dev
>        [ -z "$LOOPNUM" ] && echo "couldn't find empty loop device" &&
> return
>        mknod $loopdev b 7 $LOOPNUM
>        echo "make a loop file system with $tfile on $loopdev ($LOOPNUM)..=
."
>        dd if=3D/dev/zero of=3D$tfile bs=3D`page_size` seek=3D1024 count=
=3D1 >
> /dev/null
>        losetup $loopdev $tfile || error "can't set up $loopdev for $tfile=
"
>        mkfs.ext2 $loopdev || error "mke2fs on $loopdev"
>        mkdir -p $tdir
>        mount -t ext2 $loopdev $tdir || error "error mounting $loopdev on
> $tdir"
>        dd if=3D/dev/zero of=3D$tdir/tmp bs=3D`page_size` count=3D30 || er=
ror "dd
> write"
>        df $tdir
>        dd if=3D$tdir/tmp of=3D/dev/zero bs=3D`page_size` count=3D30 || er=
ror "dd
> read"
>        $UMOUNT $tdir
>        losetup -d $loopdev
>        rm $loopdev
> }
> run_test 54c "block device works in lustre""
>
> test_54d() {
>        f=3D"$DIR/f54d"
>        string=3D"aaaaaa"
>        mknod $f p
>        [ "$string"" `echo $string > $f | cat $f` ] || error
> }
> run_test 54d "fifo device works in lustre""
>
> test_54e() {
>        check_kernel_version 46 || return 0
>        f=3D"$DIR/f54e"
>        string=3D"aaaaaa"
>        cp -aL /dev/console $f
>        echo $string > $f || error
> }
> run_test 54e "console/tty device works in lustre""
>
> test_61() {
>        f=3D"$DIR/f61"
>        dd if=3D/dev/zero of=3D$f bs=3D`page_size` count=3D1
>        multiop $f OSMWUc || error
>        sync
> }
> run_test 61 "mmap() writes don't make sync hang""
>
> # bug 2543 - update blocks count on client
> test_66() {
>        COUNT=3D${COUNT:-8}
>        dd if=3D/dev/zero of=3D$DIR/f66 bs=3D1k count=3D$COUNT
>        sync; sleep 1; sync
>        BLOCKS=3D`ls -s $DIR/f66 | awk '{ print $1 }'`
>        [ $BLOCKS -ge $COUNT ] || error "$DIR/f66 blocks $BLOCKS < $COUNT"
> }
> run_test 66 "update inode blocks count on client""
>
> LLOOP=3D
> cleanup_68() {
>        trap 0
>        if [ ! -z "$LLOOP" ]; then
>                if swapon -s | grep -q $LLOOP; then
>                        swapoff $LLOOP || error "swapoff failed"
>                fi
>
>                losetup -d $LOOPDEV || error "detach failed"
>                unset LOOPDEV
>                unset LLOOP
>        fi
>        rm -f $DIR/f68*
> }
>
> meminfo() {
>        awk '($1" "'$1':") { print $2 }' /proc/meminfo
> }
>
> swap_used() {
>        swapon -s | awk '($1" "'$1'") { print $4 }'
> }
>
> # excercise swapping to lustre by adding a high priority swapfile entry
> # and then consuming memory until it is used.
> test_68b() {  # was test_68
>        [ "$UID" !=3D 0 ] && skip "must run as root" && return
>
>        MEMTOTAL=3D`meminfo MemTotal`
>        NR_BLOCKS=3D$((MEMTOTAL>>8))
>        [[ $NR_BLOCKS -le 2048 ]] && NR_BLOCKS=3D2048
>
>        dd if=3D/dev/zero of=3D$DIR/f68b bs=3D64k seek=3D$NR_BLOCKS count=
=3D1
>        mkswap $DIR/f68b
>
>        trap cleanup_68 EXIT
>
>        swapon -p 32767 $LLOOP || error "swapon $LLOOP failed"
>
>        echo "before: `swapon -s | grep $LLOOP`"
>        $MEMHOG $MEMTOTAL || error "error allocating $MEMTOTAL kB"
>        echo "after: `swapon -s | grep $LLOOP`"
>        SWAPUSED=3D`swap_used $LLOOP`
>
>        cleanup_68
>
>        [ $SWAPUSED -eq 0 ] && echo "no swap used???" || true
> }
> run_test 68b "support swapping to Lustre""
>
> test_72() { # bug 5695 - Test that on 2.6 remove_suid works properly
>        [ "$RUNAS_ID"" "$UID" ] && skip "RUNAS_ID =3D UID =3D $UID -- skip=
ping"
> && return
>
>        # Check that testing environment is properly set up. Skip if not
>        FAIL_ON_ERROR=3Dfalse check_runas_id_ret $RUNAS_ID $RUNAS_ID $RUNA=
S ||
> {
>                skip "User $RUNAS_ID does not exist - skipping"
>                return 0
>        }
>        touch $DIR/f72
>        chmod 777 $DIR/f72
>        chmod ug+s $DIR/f72
>        $RUNAS dd if=3D/dev/zero of=3D$DIR/f72 bs=3D512 count=3D1 || error
>        # See if we are still setuid/sgid
>        test -u $DIR/f72 -o -g $DIR/f72 && error "S/gid is not dropped on
> write"
> }
> run_test 72 "Test that remove suid works properly (bug5695)""
>
> test_78() { # bug 10901
>        NSEQ=3D5
>        F78SIZE=3D$(($(awk '/MemFree:/ { print $2 }' /proc/meminfo) / 1024=
))
>        echo "MemFree: $F78SIZE, Max file size: $MAXFREE"
>        MEMTOTAL=3D$(($(awk '/MemTotal:/ { print $2 }' /proc/meminfo) / 10=
24))
>        echo "MemTotal: $MEMTOTAL"
> # reserve 256MB of memory for the kernel and other running processes,
> # and then take 1/2 of the remaining memory for the read/write buffers.
>        if [ $MEMTOTAL -gt 512 ] ;then
>                MEMTOTAL=3D$(((MEMTOTAL - 256 ) / 2))
>        else
>                # for those poor memory-starved high-end clusters...
>                MEMTOTAL=3D$((MEMTOTAL / 2))
>        fi
>        echo "Mem to use for directio: $MEMTOTAL"
>        [ $F78SIZE -gt $MEMTOTAL ] && F78SIZE=3D$MEMTOTAL
>        [ $F78SIZE -gt 512 ] && F78SIZE=3D512
>        [ $F78SIZE -gt $((MAXFREE / 1024)) ] && F78SIZE=3D$((MAXFREE / 102=
4))
>        SMALLEST=3D`df $DIR | awk '{print $4}' | tail -1`
>        [ $SMALLEST -lt 10240 ] && \
>                skip "too small OSTSIZE, useless to run large O_DIRECT tes=
t"
> && return 0
>
>        [ $F78SIZE -gt $((SMALLEST * $OSTCOUNT / 1024 - 80)) ] && \
>                F78SIZE=3D$((SMALLEST * $OSTCOUNT / 1024 - 80))
>
>        [ "$SLOW"" "no" ] && NSEQ=3D1 && [ $F78SIZE -gt 32 ] && F78SIZE=3D=
32
>        echo "File size: $F78SIZE"
>        $SETSTRIPE $DIR/$tfile -c $OSTCOUNT || error "setstripe failed"
>        for i in `seq 1 $NSEQ`
>        do
>                FSIZE=3D$(($F78SIZE / ($NSEQ - $i + 1)))
>                echo directIO rdwr round $i of $NSEQ
>                $DIRECTIO rdwr $DIR/$tfile 0 $FSIZE 1048576||error "rdwr
> failed"
>        done
>
>        rm -f $DIR/$tfile
> }
> run_test 78 "handle large O_DIRECT writes correctly""
>
> test_80() { # bug 10718
>        dd if=3D/dev/zero of=3D$DIR/$tfile bs=3D1M count=3D1 seek=3D1M
>        sync; sleep 1; sync
>        local BEFORE=3D`date +%s`
>        cancel_lru_locks osc
>        local AFTER=3D`date +%s`
>        local DIFF=3D$((AFTER-BEFORE))
>        if [ $DIFF -gt 1 ] ; then
>                error "elapsed for 1M@1T" $DIFF"
>        fi
>        true
>        rm -f $DIR/$tfile
> }
> run_test 80 "Page eviction is equally fast at high offsets too ""
>
> test_99a() {
>        [ -z "$(which cvs 2>/dev/null)" ] && skip "could not find cvs" && =
\
>            return
>        mkdir -p $DIR/d99cvsroot
>        chown $RUNAS_ID $DIR/d99cvsroot
>        local oldPWD=3D$PWD       # bug 13584, use $TMP as working dir
>        cd $TMP
>
>        $RUNAS cvs -d $DIR/d99cvsroot init || error
>        cd $oldPWD
> }
> run_test 99a "cvs init""
>
> test_99b() {
>        [ -z "$(which cvs 2>/dev/null)" ] && skip "could not find cvs" &&
> return
>        [ ! -d $DIR/d99cvsroot ] && test_99a
>        cd /etc/init.d
>        # some versions of cvs import exit(1) when asked to import links o=
r
>        # files they can't read.  ignore those files.
>        TOIGNORE=3D$(find . -type l -printf '-I %f\n' -o \
>                        ! -perm +4 -printf '-I %f\n')
>        $RUNAS cvs -d $DIR/d99cvsroot import -m "nomesg" $TOIGNORE \
>                d99reposname vtag rtag
> }
> run_test 99b "cvs import""
>
> test_99c() {
>        [ -z "$(which cvs 2>/dev/null)" ] && skip "could not find cvs" &&
> return
>        [ ! -d $DIR/d99cvsroot ] && test_99b
>        cd $DIR
>        mkdir -p $DIR/d99reposname
>        chown $RUNAS_ID $DIR/d99reposname
>        $RUNAS cvs -d $DIR/d99cvsroot co d99reposname
> }
> run_test 99c "cvs checkout""
>
> test_99d() {
>        [ -z "$(which cvs 2>/dev/null)" ] && skip "could not find cvs" &&
> return
>        [ ! -d $DIR/d99cvsroot ] && test_99c
>        cd $DIR/d99reposname
>        $RUNAS touch foo99
>        $RUNAS cvs add -m 'addmsg' foo99
> }
> run_test 99d "cvs add""
>
> test_99e() {
>        [ -z "$(which cvs 2>/dev/null)" ] && skip "could not find cvs" &&
> return
>        [ ! -d $DIR/d99cvsroot ] && test_99c
>        cd $DIR/d99reposname
>        $RUNAS cvs update
> }
> run_test 99e "cvs update""
>
> test_99f() {
>        [ -z "$(which cvs 2>/dev/null)" ] && skip "could not find cvs" &&
> return
>        [ ! -d $DIR/d99cvsroot ] && test_99d
>        cd $DIR/d99reposname
>        $RUNAS cvs commit -m 'nomsg' foo99
>    rm -fr $DIR/d99cvsroot
> }
> run_test 99f "cvs commit""
>
> function get_named_value()
> {
>    local tag
>
>    tag=3D$1
>    while read ;do
>        line=3D$REPLY
>        case $line in
>        $tag*)
>            echo $line | sed "s/^$tag//"
>            break
>            ;;
>        esac
>    done
> }
>
> export SETUP_TEST102=3Dno
> setup_test102() {
>        [ "$SETUP_TEST102"" "yes" ] && return
>        mkdir -p $DIR/$tdir
>        chown $RUNAS_ID $DIR/$tdir
>        STRIPE_SIZE=3D65536
>        STRIPE_OFFSET=3D1
>        STRIPE_COUNT=3D$OSTCOUNT
>        [ $OSTCOUNT -gt 4 ] && STRIPE_COUNT=3D4
>
>        trap cleanup_test102 EXIT
>        cd $DIR
>        $1 $SETSTRIPE $tdir -s $STRIPE_SIZE -i $STRIPE_OFFSET -c
> $STRIPE_COUNT
>        cd $DIR/$tdir
>        for num in 1 2 3 4
>        do
>                for count in `seq 1 $STRIPE_COUNT`
>                do
>                        for offset in `seq 0 $[$STRIPE_COUNT - 1]`
>                        do
>                                local stripe_size=3D`expr $STRIPE_SIZE \*
> $num`
>                                local file=3Dfile"$num-$offset-$count"
>                                $1 $SETSTRIPE $file -s $stripe_size -i
> $offset -c $count
>                        done
>                done
>        done
>
>        cd $DIR
>        $1 $TAR cf $TMP/f102.tar $tdir --xattrs
>        SETUP_TEST102=3Dyes
> }
>
> cleanup_test102() {
>        trap 0
>        [ "$SETUP_TEST102"" "yes" ] || return 0
>        rm -f $TMP/f102.tar
>        SETUP_TEST102=3Dno
> }
>
> test_102a() {
>        local testfile=3D$DIR/xattr_testfile
>
>        rm -f $testfile
>        touch $testfile
>
>        [ "$UID" !=3D 0 ] && skip "must run as root" && return
>        [ -z "`lctl get_param -n mdc.*-mdc-*.connect_flags | grep xattr`" =
]
> && skip "must have user_xattr" && return
>
>        [ -z "$(which setfattr 2>/dev/null)" ] && skip "could not find
> setfattr" && return
>
>        echo "set/get xattr..."
>        setfattr -n trusted.name1 -v value1 $testfile || error
>        [ "`getfattr -n trusted.name1 $testfile 2> /dev/null | \
>        grep "trusted.name1"`"" "trusted.name1=3D\"value1\"" ] || error
>
>        setfattr -n user.author1 -v author1 $testfile || error
>        [ "`getfattr -n user.author1 $testfile 2> /dev/null | \
>        grep "user.author1"`"" "user.author1=3D\"author1\"" ] || error
>
>        echo "listxattr..."
>        setfattr -n trusted.name2 -v value2 $testfile || error
>        setfattr -n trusted.name3 -v value3 $testfile || error
>        [ `getfattr -d -m "^trusted" $testfile 2> /dev/null | \
>        grep "trusted.name" | wc -l` -eq 3 ] || error
>
>
>        setfattr -n user.author2 -v author2 $testfile || error
>        setfattr -n user.author3 -v author3 $testfile || error
>        [ `getfattr -d -m "^user" $testfile 2> /dev/null | \
>        grep "user" | wc -l` -eq 3 ] || error
>
>        echo "remove xattr..."
>        setfattr -x trusted.name1 $testfile || error
>        getfattr -d -m trusted $testfile 2> /dev/null | \
>        grep "trusted.name1" && error || true
>
>        setfattr -x user.author1 $testfile || error
>        getfattr -d -m user $testfile 2> /dev/null | \
>        grep "user.author1" && error || true
>
>        # b10667: setting lustre special xattr be silently discarded
>        echo "set lustre special xattr ..."
>        setfattr -n "trusted.lov" -v "invalid value" $testfile || error
>
>        rm -f $testfile
> }
> run_test 102a "user xattr test""
>
> test_106() { #bug 10921
>        mkdir -p $DIR/$tdir
>        $DIR/$tdir && error "exec $DIR/$tdir succeeded"
>        chmod 777 $DIR/$tdir || error "chmod $DIR/$tdir failed"
> }
> run_test 106 "attempt exec of dir followed by chown of that dir"
>
> test_107() {
>        CDIR=3D`pwd`
>        cd $DIR
>
>        local file=3Dcore
>        rm -f $file
>
>        local save_pattern=3D$(sysctl -n kernel.core_pattern)
>        local save_uses_pid=3D$(sysctl -n kernel.core_uses_pid)
>        sysctl -w kernel.core_pattern=3D$file
>        sysctl -w kernel.core_uses_pid=3D0
>
>        ulimit -c unlimited
>        sleep 60 &
>        SLEEPPID=3D$!
>
>        sleep 1
>
>        kill -s 11 $SLEEPPID
>        wait $SLEEPPID
>        if [ -e $file ]; then
>                size=3D`stat -c%s $file`
>                [ $size -eq 0 ] && error "Fail to create core file $file"
>        else
>                error "Fail to create core file $file"
>        fi
>        rm -f $file
>        sysctl -w kernel.core_pattern=3D$save_pattern
>        sysctl -w kernel.core_uses_pid=3D$save_uses_pid
>        cd $CDIR
> }
> run_test 107 "Coredump on SIG"
>
> test_110() {
>        mkdir -p $DIR/d110
>        mkdir
> $DIR/d110/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
> || error "mkdir with 255 char fail"
>        mkdir
> $DIR/d110/bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb=
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb=
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb=
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
> && error "mkdir with 256 char should fail, but not"
>        touch
> $DIR/d110/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> || error "create with 255 char fail"
>        touch
> $DIR/d110/yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
> && error ""create with 256 char should fail, but not
>
>        ls -l $DIR/d110
>    rm -fr $DIR/d110
> }
> run_test 110 "filename length checking"
>
> test_119a() # bug 11737
> {
>        BSIZE=3D$((512 * 1024))
>        directio write $DIR/$tfile 0 1 $BSIZE
>        # We ask to read two blocks, which is more than a file size.
>        # directio will indicate an error when requested and actual
>        # sizes aren't equal (a normal situation in this case) and
>        # print actual read amount.
>        NOB=3D`directio read $DIR/$tfile 0 2 $BSIZE | awk '/error/ {print
> $6}'`
>        if [ "$NOB" !=3D "$BSIZE" ]; then
>                error "read $NOB bytes instead of $BSIZE"
>        fi
>        rm -f $DIR/$tfile
> }
> run_test 119a "Short directIO read must return actual read amount"
>
> test_119b() # bug 11737
> {
>        dd if=3D/dev/zero of=3D$DIR/$tfile bs=3D1M count=3D1 seek=3D1 || e=
rror "dd
> failed"
>        sync
>        multiop $DIR/$tfile oO_RDONLY:O_DIRECT:r$((2048 * 1024)) || \
>                error "direct read failed"
>        rm -f $DIR/$tfile
> }
> run_test 119b "Sparse directIO read must return actual read amount"
>
> test_119c() # bug 13099
> {
>        BSIZE=3D1048576
>        directio write $DIR/$tfile 3 1 $BSIZE || error "direct write faile=
d"
>        directio readhole $DIR/$tfile 0 2 $BSIZE || error "reading hole
> failed"
>        rm -f $DIR/$tfile
> }
> run_test 119c "Testing for direct read hitting hole"
>
> test_126() { # bug 12829/13455
>        [ "$UID" !=3D 0 ] && echo "skipping $TESTNAME (must run as root)" =
&&
> return
>
>        $RUNAS -u 0 -g 1 touch $DIR/$tfile || error "touch failed"
>        gid=3D`ls -n $DIR/$tfile | awk '{print $4}'`
>        rm -f $DIR/$tfile
>        [ $gid -eq "1" ] || error "gid is set to" $gid "instead of 1"
> }
> run_test 126 "check that the fsgid provided by the client is taken into
> account"
>
> OLDIFS=3D"$IFS"
> cleanup_130() {
>        trap 0
>        IFS=3D"$OLDIFS"
> }
>
> test_130a() {
>        filefrag_op=3D$(filefrag -e 2>&1 | grep "invalid option")
>        [ -n "$filefrag_op" ] && skip "filefrag does not support FIEMAP" &=
&
> return
>
>        trap cleanup_130 EXIT RETURN
>
>        local fm_file=3D$DIR/$tfile
>        dd if=3D/dev/zero of=3D$fm_file bs=3D65536 count=3D1 || error "dd =
failed for
> $fm_file"
>
>        filefrag -ves $fm_file || error "filefrag $fm_file failed"
>        filefrag_op=3D`filefrag -ve $fm_file | grep -A 100 "ext:" | grep -=
v
> "ext:" | grep -v "found"`
>
>        start_blk=3D`echo $filefrag_op | cut -d: -f2 | cut -d. -f1`
>        IFS=3D$'\n'
>        tot_len=3D0
>        for line in $filefrag_op; do
>                ext_len=3D`echo $line | cut -d: -f4`
>                (( tot_len +=3D ext_len ))
>        done
>
>        if (( start_blk !=3D 0 || tot_len !=3D 64 )); then
>                cleanup_130
>                error "FIEMAP on 1-stripe file($fm_file) failed;"
>                return
>        fi
>
>        cleanup_130
>
>        echo "FIEMAP on single striped file succeeded"
> }
> run_test 130a "FIEMAP (1-stripe file)"
>
> test_130e() {
>        skip "this test needs cleanup for non-lustre"
>        filefrag_op=3D$(filefrag -e 2>&1 | grep "invalid option")
>        [ -n "$filefrag_op" ] && skip "filefrag does not support FIEMAP" &=
&
> return
>
>        trap cleanup_130 EXIT RETURN
>
>        local fm_file=3D$DIR/$tfile
>        NUM_BLKS=3D512
>        EXPECTED_LEN=3D$(( (NUM_BLKS / 2) * 4 ))
>        for ((i" 0; i < $NUM_BLKS; i++))
>        do
>                dd if=3D/dev/zero of=3D$fm_file count=3D1 bs=3D4096 seek=
=3D$((2*$i))
> conv=3Dnotrunc > /dev/null 2>&1
>        done
>
>        filefrag -ves $fm_file || error "filefrag $fm_file failed"
>        filefrag_op=3D`filefrag -ve $fm_file | grep -A 750 "ext:" | grep -=
v
> "ext:" | grep -v "found"`
>
>        IFS=3D$'\n'
>        tot_len=3D0
>        for line in $filefrag_op; do
>                ext_len=3D`echo $line | cut -d: -f4`
>                (( tot_len +=3D ext_len ))
>        done
>        if (( tot_len !=3D $EXPECTED_LEN )); then
>                cleanup_130
>                error "FIEMAP on $fm_file failed; len $tot_len !=3D
> $EXPECTED_LEN"
>                return
>        fi
>
>        cleanup_130
>
>        echo "FIEMAP with continuation calls succeeded"
> }
> run_test 130e "FIEMAP (test continuation FIEMAP calls)"
>
> # Test for writev/readv
> test_131a() {
>        rwv -f $DIR/$tfile -w -n 3 524288 1048576 1572864 || \
>        error "writev test failed"
>        rwv -f $DIR/$tfile -r -v -n 2 1572864 1048576 || \
>        error "readv failed"
>        rm -f $DIR/$tfile
> }
> run_test 131a "test iov's crossing stripe boundary for writev/readv"
>
> test_131b() {
>        rwv -f $DIR/$tfile -w -a -n 3 524288 1048576 1572864 || \
>        error "append writev test failed"
>        rwv -f $DIR/$tfile -w -a -n 2 1572864 1048576 || \
>        error "append writev test failed"
>        rm -f $DIR/$tfile
> }
> run_test 131b "test append writev"
>
> test_131c() {
>        rwv -f $DIR/$tfile -w -d -n 1 1048576 || return 0
>        error "NOT PASS"
> }
> run_test 131c "test read/write on file w/o objects"
>
> test_131d() {
>        rwv -f $DIR/$tfile -w -n 1 1572864
>        NOB=3D`rwv -f $DIR/$tfile -r -n 3 524288 524288 1048576 | awk '/er=
ror/
> {print $6}'`
>        if [ "$NOB" !=3D 1572864 ]; then
>                error "Short read filed: read $NOB bytes instead of 157286=
4"
>        fi
>        rm -f $DIR/$tfile
> }
> run_test 131d "test short read"
>
> test_131e() {
>        rwv -f $DIR/$tfile -w -s 1048576 -n 1 1048576
>        rwv -f $DIR/$tfile -r -z -s 0 -n 1 524288 || \
>        error "read hitting hole failed"
>        rm -f $DIR/$tfile
> }
> run_test 131e "test read hitting hole"
>
> test_140() { #bug-17379
>        mkdir -p $DIR/$tdir || error "Creating dir $DIR/$tdir"
>        cd $DIR/$tdir || error "Changing to $DIR/$tdir"
>        cp /usr/bin/stat . || error "Copying stat to $DIR/$tdir"
>
>        # VFS limits max symlink depth to 8
>        local i=3D0
>        while i=3D`expr $i + 1`; do
>                mkdir -p $i || error "Creating dir $i"
>                cd $i || error "Changing to $i"
>                ln -s ../stat stat || error "Creating stat symlink"
>                # Read the symlink until ELOOP present,
>                # not LBUGing the system is considered success,
>                # we didn't overrun the stack.
>                $OPENFILE -f O_RDONLY stat >/dev/null 2>&1; ret=3D$?
>                [ $ret -ne 0 ] && {
>                        if [ $ret -eq 40 ]; then
>                                break  # -ELOOP
>                        else
>                                error "Open stat symlink"
>                                return
>                        fi
>                }
>        done
>        i=3D`expr $i - 1`
>        echo "The symlink depth" $i"
>        [ $i -eq 8 ] || error "Invalid symlink depth"
> }
> run_test 140 "Check reasonable stack depth (shouldn't LBUG)""
>
> test_154() {
>        # do directio so as not to populate the page cache
>        log "creating a 10 Mb file"
>        multiop $DIR/$tfile oO_CREAT:O_DIRECT:O_RDWR:w$((10*1048576))c ||
> error "multiop failed while creating a file"
>        log "starting reads"
>        dd if=3D$DIR/$tfile of=3D/dev/null bs=3D4096 &
>        log "truncating the file"
>        multiop $DIR/$tfile oO_TRUNC:c || error "multiop failed while
> truncating the file"
>        log "killing dd"
>        kill %+ || true # reads might have finished
>        echo "wait until dd is finished"
>        wait
>        log "removing the temporary file"
>        rm -rf $DIR/$tfile || error "tmp file removal failed"
> }
> run_test 154 "parallel read and truncate should not deadlock""
>
> echo "$0: completed"
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



--=20
Regards & Thanks--
Subrata

--00163646c228cdfa43046a925441
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Andreas,<br><br><div class=3D"gmail_quote">On Sat, May 23, 2009 at 3:06 =
AM, Andreas Dilger <span dir=3D"ltr">&lt;<a href=3D"mailto:adilger-xsfywfwIY+M@public.gmane.org"=
>adilger-xsfywfwIY+M@public.gmane.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote"=
 style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.=
8ex; padding-left: 1ex;">
Below are included some of the tests from the Lustre &quot;sanity.sh&quot; =
script,<br>
which tests filesystem behaviour in a variety of ways. =C2=A0Some of them a=
re<br>
very simple and might concievably be removed, but are not necessarily bad.<=
br>
I&#39;ve removed the tests that depend on Lustre-specific behaviour.<br>
<br>
It probably isn&#39;t useful to use this test script directly, since it<br>
depends on a number of helper functions, but it is definitely useful<br>
as a starting point for adding new tests to xfstests.<br>
<br>
Unfortunately, a bunch of tests had to be removed since they depend on<br>
Lustre&#39;s fault-injection code, but they would be useful for testing<br>
generic filesystem behaviour (e.g. ENOMEM or ENOSPC handling). =C2=A0There<=
br>
is also a helper program we use &quot;multiop&quot; which is a toolbox prog=
ram<br>
that I could supply separately, if you want.</blockquote><div><br>How about=
 understanding these and find out if they can be made part of LTP as well=
=C2=A0 ? Any objection(s) ?<br><br>Regards--<br>Subrata<br>=C2=A0<br></div>=
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
<br>
Cheers, Andreas<br>
--<br>
Andreas Dilger<br>
Sr. Staff Engineer, Lustre Group<br>
Sun Microsystems of Canada, Inc.<br>
<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D<br>
<br>
TMP=3D${TMP:-/tmp}<br>
<br>
[ -f $DIR/d52a/foo ] &amp;&amp; chattr -a $DIR/d52a/foo<br>
[ -f $DIR/d52b/foo ] &amp;&amp; chattr -i $DIR/d52b/foo<br>
rm -rf $DIR/[Rdfs][0-9]*<br>
<br>
# $RUNAS_ID may get set incorrectly somewhere else<br>
[ $UID -eq 0 -a $RUNAS_ID -eq 0 ] &amp;&amp; error &quot;\$RUNAS_ID set to =
0, but \$UID is also 0!&quot;<br>
<br>
<br>
echo &quot;preparing for tests involving mounts&quot;<br>
EXT2_DEV=3D${EXT2_DEV:-$TMP/SANITY.LOOP}<br>
touch $EXT2_DEV<br>
mke2fs -j -F $EXT2_DEV 8000 &gt; /dev/null<br>
echo # add a newline after mke2fs.<br>
<br>
umask 077<br>
<br>
test_0() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/$tfile || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $DIR/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/$tfile || error<br>
}<br>
run_test 0 &quot;touch .../$tfile ; rm .../$tfile&quot;<br>
<br>
test_0b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 0755 $DIR || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -p 0755 $DIR || error<br>
}<br>
run_test 0b &quot;chmod 0755 $DIR&quot;<br>
<br>
test_1a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d1/d2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d1/d2 &amp;&amp; error &quot;we expe=
ct EEXIST, but not returned&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/d1/d2 || error<br>
}<br>
run_test 1a &quot;mkdir .../d1; mkdir .../d1/d2&quot;<br>
<br>
test_1b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rmdir $DIR/d1/d2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rmdir $DIR/d1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/d1 || error<br>
}<br>
run_test 1b &quot;rmdir .../d1/d2; rmdir .../d1&quot;<br>
<br>
test_2a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d2/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/d2/f || error<br>
}<br>
run_test 2a &quot;mkdir .../d2; touch .../d2/f&quot;<br>
<br>
test_2b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -r $DIR/d2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/d2 || error<br>
}<br>
run_test 2b &quot;rm -r .../d2; checkstat .../d2/f&quot;<br>
<br>
test_3a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d3<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/d3 || error<br>
}<br>
run_test 3a &quot;mkdir .../d3&quot;<br>
<br>
test_3b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ ! -d $DIR/d3 ]; then<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d3<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d3/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/d3/f || error<br>
}<br>
run_test 3b &quot;touch .../d3/f&quot;<br>
<br>
test_3c() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -r $DIR/d3<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/d3 || error<br>
}<br>
run_test 3c &quot;rm -r .../d3&quot;<br>
<br>
test_4a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d4<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/d4 || error<br>
}<br>
run_test 4a &quot;mkdir .../d4&quot;<br>
<br>
test_4b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ ! -d $DIR/d4 ]; then<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d4<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d4/d2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/d4/d2 || error<br>
}<br>
run_test 4b &quot;mkdir .../d4/d2&quot;<br>
<br>
test_5() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d5<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d5/d2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 0707 $DIR/d5/d2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir -p 0707 $DIR/d5/d2 || error<b=
r>
}<br>
run_test 5 &quot;mkdir .../d5 .../d5/d2; chmod .../d5/d2&quot;<br>
<br>
test_6a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/f6a<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 0666 $DIR/f6a || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file -p 0666 -u \#$UID $DIR/f6a |=
| error<br>
}<br>
run_test 6a &quot;touch .../f6a; chmod .../f6a&quot;<br>
<br>
test_6b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $RUNAS_ID -eq $UID ] &amp;&amp; skip &quot;RU=
NAS_ID&quot; UID =3D $UID -- skipping&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ ! -f $DIR/f6a ]; then<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/f6a<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 0666 $DIR/f6a=
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS chmod 0444 $DIR/f6a &amp;&amp; error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file -p 0666 -u \#$UID $DIR/f6a |=
| error<br>
}<br>
run_test 6b &quot;$RUNAS chmod .../f6a (should return error)&quot;&quot;<br=
>
<br>
test_6c() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $RUNAS_ID -eq $UID ] &amp;&amp; skip &quot;RU=
NAS_ID&quot; UID =3D $UID -- skipping&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/f6c<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chown $RUNAS_ID $DIR/f6c || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file -u \#$RUNAS_ID $DIR/f6c || e=
rror<br>
}<br>
run_test 6c &quot;touch .../f6c; chown .../f6c&quot;<br>
<br>
test_6d() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $RUNAS_ID -eq $UID ] &amp;&amp; skip &quot;RU=
NAS_ID&quot; UID =3D $UID -- skipping&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ ! -f $DIR/f6c ]; then<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/f6c<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chown $RUNAS_ID $DI=
R/f6c<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS chown $UID $DIR/f6c &amp;&amp; error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file -u \#$RUNAS_ID $DIR/f6c || e=
rror<br>
}<br>
run_test 6d &quot;$RUNAS chown .../f6c (should return error)&quot;&quot;<br=
>
<br>
test_6e() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $RUNAS_ID -eq $UID ] &amp;&amp; skip &quot;RU=
NAS_ID&quot; UID =3D $UID -- skipping&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/f6e<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chgrp $RUNAS_ID $DIR/f6e || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file -u \#$UID -g \#$RUNAS_ID $DI=
R/f6e || error<br>
}<br>
run_test 6e &quot;touch .../f6e; chgrp .../f6e&quot;<br>
<br>
test_6f() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $RUNAS_ID -eq $UID ] &amp;&amp; skip &quot;RU=
NAS_ID&quot; UID =3D $UID -- skipping&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ ! -f $DIR/f6e ]; then<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/f6e<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chgrp $RUNAS_ID $DI=
R/f6e<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS chgrp $UID $DIR/f6e &amp;&amp; error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file -u \#$UID -g \#$RUNAS_ID $DI=
R/f6e || error<br>
}<br>
run_test 6f &quot;$RUNAS chgrp .../f6e (should return error)&quot;&quot;<br=
>
<br>
test_6g() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $RUNAS_ID -eq $UID ] &amp;&amp; skip &quot;RU=
NAS_ID&quot; UID =3D $UID -- skipping&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d6g || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 777 $DIR/d6g || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS mkdir $DIR/d6g/d || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod g+s $DIR/d6g/d || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d6g/d/subdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -g \#$RUNAS_ID $DIR/d6g/d/subdir || =
error<br>
}<br>
run_test 6g &quot;Is new dir in sgid dir inheriting group?&quot;<br>
<br>
test_6h() { # bug 7331<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $RUNAS_ID -eq $UID ] &amp;&amp; skip &quot;RU=
NAS_ID&quot; UID =3D $UID -- skipping&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/f6h || error &quot;touch failed&quot=
;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chown $RUNAS_ID:$RUNAS_ID $DIR/f6h || error &qu=
ot;initial chown failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS -G$RUNAS_ID chown $RUNAS_ID:0 $DIR/f6h &=
amp;&amp; error &quot;chown worked&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file -u \#$RUNAS_ID -g \#$RUNAS_I=
D $DIR/f6h || error<br>
}<br>
run_test 6h &quot;$RUNAS chown RUNAS_ID.0 .../f6h (should return error)&quo=
t;<br>
<br>
test_7a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d7<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$MCREATE $DIR/d7/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 0666 $DIR/d7/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file -p 0666 $DIR/d7/f || error<b=
r>
}<br>
run_test 7a &quot;mkdir .../d7; mcreate .../d7/f; chmod .../d7/f&quot;&quot=
;<br>
<br>
test_7b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ ! -d $DIR/d7 ]; then<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d7<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$MCREATE $DIR/d7/f2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo -n foo &gt; $DIR/d7/f2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ &quot;`cat $DIR/d7/f2`&quot;&quot; &quot;foo&=
quot; ] || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file -s 3 $DIR/d7/f2 || error<br>
}<br>
run_test 7b &quot;mkdir .../d7; mcreate d7/f2; echo foo &gt; d7/f2&quot;<br=
>
<br>
test_8() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d8<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d8/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 0666 $DIR/d8/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file -p 0666 $DIR/d8/f || error<b=
r>
}<br>
run_test 8 &quot;mkdir .../d8; touch .../d8/f; chmod .../d8/f&quot;<br>
<br>
test_9() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d9<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d9/d2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d9/d2/d3<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/d9/d2/d3 || error<br>
}<br>
run_test 9 &quot;mkdir .../d9 .../d9/d2 .../d9/d2/d3&quot;<br>
<br>
test_10() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d10<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d10/d2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d10/d2/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/d10/d2/f || error<br>
}<br>
run_test 10 &quot;mkdir .../d10 .../d10/d2; touch .../d10/d2/f&quot;<br>
<br>
test_11() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d11<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d11/d2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 0666 $DIR/d11/d2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 0705 $DIR/d11/d2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir -p 0705 $DIR/d11/d2 || error<=
br>
}<br>
run_test 11 &quot;mkdir .../d11 d11/d2; chmod .../d11/d2&quot;<br>
<br>
test_12() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d12<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d12/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 0666 $DIR/d12/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 0654 $DIR/d12/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file -p 0654 $DIR/d12/f || error<=
br>
}<br>
run_test 12 &quot;touch .../d12/f; chmod .../d12/f .../d12/f&quot;<br>
<br>
test_13() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d13<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D/dev/zero of=3D$DIR/d13/f count=3D10<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0&gt; =C2=A0$DIR/d13/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file -s 0 $DIR/d13/f || error<br>
}<br>
run_test 13 &quot;creat .../d13/f; dd .../d13/f; &gt; .../d13/f&quot;<br>
<br>
test_14() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d14<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d14/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $DIR/d14/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/d14/f || error<br>
}<br>
run_test 14 &quot;touch .../d14/f; rm .../d14/f; rm .../d14/f&quot;<br>
<br>
test_15() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d15<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d15/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mv $DIR/d15/f $DIR/d15/f2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/d15/f2 || error<br>
}<br>
run_test 15 &quot;touch .../d15/f; mv .../d15/f .../d15/f2&quot;<br>
<br>
test_16() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d16<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d16/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -rf $DIR/d16/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/d16/f || error<br>
}<br>
run_test 16 &quot;touch .../d16/f; rm -rf .../d16/f&quot;<br>
<br>
test_17a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d17<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d17/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $DIR/d17/f $DIR/d17/l-exist<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -l $DIR/d17<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -l $DIR/d17/f $DIR/d17/l-exist || er=
ror<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -f -t f $DIR/d17/l-exist || error<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/d17/l-exist<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/d17/l-exist || error<br>
}<br>
run_test 17a &quot;symlinks: create, remove (real)&quot;<br>
<br>
test_17b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d17<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s no-such-file $DIR/d17/l-dangle<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -l $DIR/d17<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -l no-such-file $DIR/d17/l-dangle ||=
 error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -fa $DIR/d17/l-dangle || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/d17/l-dangle<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/d17/l-dangle || error<br>
}<br>
run_test 17b &quot;symlinks: create, remove (dangling)&quot;<br>
<br>
test_17c() { # bug 3440 - don&#39;t save failed open RPC for replay<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d17<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s foo $DIR/d17/f17c<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cat $DIR/d17/f17c &amp;&amp; error &quot;opened=
 non-existent symlink&quot; || true<br>
}<br>
run_test 17c &quot;symlinks: open dangling (should return error)&quot;&quot=
;<br>
<br>
test_17d() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d17<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s foo $DIR/d17/f17d<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d17/f17d || error &quot;creating to =
new symlink&quot;<br>
}<br>
run_test 17d &quot;symlinks: create dangling&quot;<br>
<br>
test_17e() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/$tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local foo=3D$DIR/$tdir/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $foo $foo || error &quot;create symlink f=
ailed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -l $foo || error &quot;ls -l failed&quot;<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls $foo &amp;&amp; error &quot;ls not failed&qu=
ot; || true<br>
}<br>
run_test 17e &quot;symlinks: create recursive symlink (should return error)=
&quot;&quot;<br>
<br>
test_17f() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d17f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s 1234567890/2234567890/3234567890/42345678=
90 $DIR/d17f/111<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s 1234567890/2234567890/3234567890/42345678=
90/5234567890/6234567890 $DIR/d17f/222<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s 1234567890/2234567890/3234567890/42345678=
90/5234567890/6234567890/7234567890/8234567890 $DIR/d17f/333<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s 1234567890/2234567890/3234567890/42345678=
90/5234567890/6234567890/7234567890/8234567890/9234567890/a234567890/b23456=
7890 $DIR/d17f/444<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s 1234567890/2234567890/3234567890/42345678=
90/5234567890/6234567890/7234567890/8234567890/9234567890/a234567890/b23456=
7890/c234567890/d234567890/f234567890 $DIR/d17f/555<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s 1234567890/2234567890/3234567890/42345678=
90/5234567890/6234567890/7234567890/8234567890/9234567890/a234567890/b23456=
7890/c234567890/d234567890/f234567890/aaaaaaaaaa/bbbbbbbbbb/cccccccccc/dddd=
dddddd/eeeeeeeeee/ffffffffff/ $DIR/d17f/666<br>

 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -l =C2=A0$DIR/d17f<br>
}<br>
run_test 17f &quot;symlinks: long and very long symlink name&quot;<br>
<br>
test_17g() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/$tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0LONGSYMLINK=3D&quot;$(dd if=3D/dev/zero bs=3D40=
95 count=3D1 | tr &#39;\0&#39; &#39;x&#39;)&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $LONGSYMLINK $DIR/$tdir/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -l $DIR/$tdir<br>
}<br>
run_test 17g &quot;symlinks: really long symlink name&quot;<br>
<br>
test_17h() { #bug 17378<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/$tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$SETSTRIPE $DIR/$tdir -c -1<br>
#define OBD_FAIL_MDS_LOV_PREP_CREATE 0x141<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0do_facet mds lctl set_param fail_loc=3D0x800001=
41<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/$tdir/$tfile || true<br>
}<br>
run_test 17h &quot;create objects: lov_free_memmd() doesn&#39;t lbug&quot;<=
br>
<br>
test_18() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls $DIR || error<br>
}<br>
run_test 18 &quot;touch .../f ; ls ...&quot;<br>
<br>
test_19a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/f19<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -l $DIR<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $DIR/f19<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/f19 || error<br>
}<br>
run_test 19a &quot;touch .../f19 ; ls -l ... ; rm .../f19&quot;<br>
<br>
test_19b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -l $DIR/f19 &amp;&amp; error || true<br>
}<br>
run_test 19b &quot;ls -l .../f19 (should return error)&quot;<br>
<br>
test_19c() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $RUNAS_ID -eq $UID ] &amp;&amp; skip &quot;RU=
NAS_ID&quot; UID =3D $UID -- skipping&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS touch $DIR/f19 &amp;&amp; error || true<=
br>
}<br>
run_test 19c &quot;$RUNAS touch .../f19 (should return error)&quot;&quot;<b=
r>
<br>
test_19d() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cat $DIR/f19 &amp;&amp; error || true<br>
}<br>
run_test 19d &quot;cat .../f19 (should return error)&quot;<br>
<br>
test_20() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $DIR/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0log &quot;1 done&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $DIR/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0log &quot;2 done&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $DIR/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0log &quot;3 done&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/f || error<br>
}<br>
run_test 20 &quot;touch .../f ; ls -l ...&quot;<br>
<br>
test_21() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d21<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -f $DIR/d21/dangle ] &amp;&amp; rm -f $DIR/d2=
1/dangle<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s dangle $DIR/d21/link<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo foo &gt;&gt; $DIR/d21/link<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cat $DIR/d21/dangle<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t link $DIR/d21/link || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -f -t file $DIR/d21/link || error<br=
>
}<br>
run_test 21 &quot;write to dangling link&quot;<br>
<br>
test_22() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0WDIR=3D$DIR/$tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $WDIR<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chown $RUNAS_ID $WDIR<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0(cd $WDIR || error &quot;cd $WDIR failed&quot;;=
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS tar cf - /etc/hosts /etc/sysconfig/netwo=
rk | \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS tar xf -)<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -lR $WDIR/etc || error &quot;ls -lR $WDIR/et=
c failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $WDIR/etc || error &quot;chec=
kstat -t dir failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -u \#$RUNAS_ID $WDIR/etc || error &q=
uot;checkstat -u failed&quot;<br>
}<br>
run_test 22 &quot;unpack tar archive as non-root user&quot;<br>
<br>
test_23() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/$tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local file=3D$DIR/$tdir/$tfile<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0openfile -f O_CREAT:O_EXCL $file || error &quot=
;$file create failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0openfile -f O_CREAT:O_EXCL $file &amp;&amp;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;$file r=
ecreate succeeded&quot; || true<br>
}<br>
run_test 23 &quot;O_CREAT|O_EXCL in subdir&quot;<br>
<br>
test_24a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &#39;=3D=3D rename sanity&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &#39;-- same directory rename&#39;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/R1/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mv $DIR/R1/f $DIR/R1/g<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/R1/g || error<br>
}<br>
run_test 24a &quot;touch .../R1/f; rename .../R1/f .../R1/g&quot;<br>
<br>
test_24b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/R2/{f,g}<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mv $DIR/R2/f $DIR/R2/g<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/R2/f || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/R2/g || error<br>
}<br>
run_test 24b &quot;touch .../R2/{f,g}; rename .../R2/f .../R2/g&quot;<br>
<br>
test_24c() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R3<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R3/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mv $DIR/R3/f $DIR/R3/g<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/R3/f || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/R3/g || error<br>
}<br>
run_test 24c &quot;mkdir .../R3/f; rename .../R3/f .../R3/g&quot;<br>
<br>
test_24d() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R4<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R4/{f,g}<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mrename $DIR/R4/f $DIR/R4/g<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/R4/f || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/R4/g || error<br>
}<br>
run_test 24d &quot;mkdir .../R4/{f,g}; rename .../R4/f .../R4/g&quot;<br>
<br>
test_24e() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &#39;-- cross directory renames --&#39;<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R5{a,b}<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/R5a/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mv $DIR/R5a/f $DIR/R5b/g<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/R5a/f || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/R5b/g || error<br>
}<br>
run_test 24e &quot;touch .../R5a/f; rename .../R5a/f .../R5b/g&quot;<br>
<br>
test_24f() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R6{a,b}<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/R6a/f $DIR/R6b/g<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mv $DIR/R6a/f $DIR/R6b/g<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/R6a/f || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/R6b/g || error<br>
}<br>
run_test 24f &quot;touch .../R6a/f R6b/g; mv .../R6a/f .../R6b/g&quot;&quot=
;<br>
<br>
test_24g() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R7{a,b}<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R7a/d<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mv $DIR/R7a/d $DIR/R7b/e<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/R7a/d || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/R7b/e || error<br>
}<br>
run_test 24g &quot;mkdir .../R7{a,b}/d; mv .../R7a/d .../R7b/e&quot;<br>
<br>
test_24h() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R8{a,b}<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R8a/d $DIR/R8b/e<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mrename $DIR/R8a/d $DIR/R8b/e<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/R8a/d || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/R8b/e || error<br>
}<br>
run_test 24h &quot;mkdir .../R8{a,b}/{d,e}; rename .../R8a/d .../R8b/e&quot=
;<br>
<br>
test_24i() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;-- rename error cases&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R9<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R9/a<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/R9/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mrename $DIR/R9/f $DIR/R9/a<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/R9/f || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir =C2=A0$DIR/R9/a || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/R9/a/f || error<br>
}<br>
run_test 24i &quot;rename file to dir error: touch f ; mkdir a ; rename f a=
&quot;<br>
<br>
test_24j() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R10<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mrename $DIR/R10/f $DIR/R10/g<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/R10 || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/R10/f || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/R10/g || error<br>
}<br>
run_test 24j &quot;source does not exist&quot;<br>
<br>
test_24k() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R11a $DIR/R11a/d<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/R11a/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mv $DIR/R11a/f $DIR/R11a/d<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/R11a/f || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/R11a/d/f || error<br>
}<br>
run_test 24k &quot;touch .../R11a/f; mv .../R11a/f .../R11a/d&quot;<br>
<br>
# bug 2429 - rename foo foo foo creates invalid file<br>
test_24l() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0f=3D&quot;$DIR/f24l&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0multiop $f OcNs || error<br>
}<br>
run_test 24l &quot;Renaming a file to itself&quot;<br>
<br>
test_24m() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0f=3D&quot;$DIR/f24m&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0multiop $f OcLN ${f}2 ${f}2 || error &quot;link=
 ${f}2 ${f}2 failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# on ext3 this does not remove either the sourc=
e or target files<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# though the &quot;expected&quot; operation wou=
ld be to remove the source<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file ${f} || error &quot;${f} mis=
sing&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file ${f}2 || error &quot;${f}2 m=
issing&quot;<br>
}<br>
run_test 24m &quot;Renaming a file to a hard link to itself&quot;<br>
<br>
test_24n() {<br>
 =C2=A0 =C2=A0f=3D&quot;$DIR/f24n&quot;<br>
 =C2=A0 =C2=A0# this stats the old file after it was renamed, so it should =
fail<br>
 =C2=A0 =C2=A0touch ${f}<br>
 =C2=A0 =C2=A0$CHECKSTAT ${f}<br>
 =C2=A0 =C2=A0mv ${f} ${f}.rename<br>
 =C2=A0 =C2=A0$CHECKSTAT ${f}.rename<br>
 =C2=A0 =C2=A0$CHECKSTAT -a ${f}<br>
}<br>
run_test 24n &quot;Statting the old file after renaming (Posix rename 2)&qu=
ot;<br>
<br>
test_24o() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0check_kernel_version 37 || return 0<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d24o<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rename_many -s random -v -n 10 $DIR/d24o<br>
}<br>
run_test 24o &quot;rename of files during htree split&quot;<br>
<br>
test_24p() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R12{a,b}<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0DIRINO=3D`ls -lid $DIR/R12a | awk &#39;{ print =
$1 }&#39;`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mrename $DIR/R12a $DIR/R12b<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/R12a || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/R12b || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0DIRINO2=3D`ls -lid $DIR/R12b | awk &#39;{ print=
 $1 }&#39;`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ &quot;$DIRINO&quot;&quot; &quot;$DIRINO2&quot=
; ] || error &quot;R12a $DIRINO !=3D R12b $DIRINO2&quot;<br>
}<br>
run_test 24p &quot;mkdir .../R12{a,b}; rename .../R12a .../R12b&quot;<br>
<br>
test_24q() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R13{a,b}<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0DIRINO=3D`ls -lid $DIR/R13a | awk &#39;{ print =
$1 }&#39;`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0multiop_bg_pause $DIR/R13b D_c || return 1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0MULTIPID=3D$!<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mrename $DIR/R13a $DIR/R13b<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/R13a || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/R13b || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0DIRINO2=3D`ls -lid $DIR/R13b | awk &#39;{ print=
 $1 }&#39;`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ &quot;$DIRINO&quot;&quot; &quot;$DIRINO2&quot=
; ] || error &quot;R13a $DIRINO !=3D R13b $DIRINO2&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0kill -USR1 $MULTIPID<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0wait $MULTIPID || error &quot;multiop close fai=
led&quot;<br>
}<br>
run_test 24q &quot;mkdir .../R13{a,b}; open R13b rename R13a R13b&quot;&quo=
t;<br>
<br>
test_24r() { #bug 3789<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R14a $DIR/R14a/b<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mrename $DIR/R14a $DIR/R14a/b &amp;&amp; error =
&quot;rename to subdir worked!&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/R14a || error &quot;$DIR=
/R14a missing&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/R14a/b || error &quot;$D=
IR/R14a/b missing&quot;<br>
}<br>
run_test 24r &quot;mkdir .../R14a/b; rename .../R14a .../R14a/b&quot;<br>
<br>
test_24s() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R15a $DIR/R15a/b $DIR/R15a/b/c<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mrename $DIR/R15a $DIR/R15a/b/c &amp;&amp; erro=
r &quot;rename to sub-subdir worked!&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/R15a || error &quot;$DIR=
/R15a missing&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/R15a/b/c || error &quot;=
$DIR/R15a/b/c missing&quot;<br>
}<br>
run_test 24s &quot;mkdir .../R15a/b/c; rename .../R15a .../R15a/b/c&quot;&q=
uot;<br>
test_24t() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/R16a $DIR/R16a/b $DIR/R16a/b/c<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mrename $DIR/R16a/b/c $DIR/R16a &amp;&amp; erro=
r &quot;rename to sub-subdir worked!&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/R16a || error &quot;$DIR=
/R16a missing&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/R16a/b/c || error &quot;=
$DIR/R16a/b/c missing&quot;<br>
}<br>
run_test 24t &quot;mkdir .../R16a/b/c; rename .../R16a/b/c .../R16a&quot;&q=
uot;<br>
<br>
test_24u() { # bug12192<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0multiop $DIR/$tfile C2w$((2048 * 1024))c || err=
or<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -s $((2048 * 1024)) $DIR/$tfile || e=
rror &quot;wrong file size&quot;<br>
}<br>
run_test 24u &quot;create stripe file&quot;<br>
<br>
test_25a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &#39;=3D=3D symlink sanity&quot;<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d25<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s d25 $DIR/s25<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/s25/foo || error<br>
}<br>
run_test 25a &quot;create file in symlinked directory&quot;<br>
<br>
test_25b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ ! -d $DIR/d25 ] &amp;&amp; test_25a<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/s25/foo || error<br>
}<br>
run_test 25b &quot;lookup file in symlinked directory&quot;&quot;<br>
<br>
test_26a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d26<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d26/d26-2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s d26/d26-2 $DIR/s26<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/s26/foo || error<br>
}<br>
run_test 26a &quot;multiple component symlink&quot;&quot;<br>
<br>
test_26b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d26b/d26-2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s d26b/d26-2/foo $DIR/s26-2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/s26-2 || error<br>
}<br>
run_test 26b &quot;multiple component symlink at end of lookup&quot;&quot;<=
br>
<br>
test_26c() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d26.2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d26.2/foo<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s d26.2 $DIR/s26.2-1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s s26.2-1 $DIR/s26.2-2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s s26.2-2 $DIR/s26.2-3<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 0666 $DIR/s26.2-3/foo<br>
}<br>
run_test 26c &quot;chain of symlinks&quot;&quot;<br>
<br>
# recursive symlinks (bug 439)<br>
test_26d() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s d26-3/foo $DIR/d26-3<br>
}<br>
run_test 26d &quot;create multiple component recursive symlink&quot;&quot;<=
br>
<br>
test_26e() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ ! -h $DIR/d26-3 ] &amp;&amp; test_26d<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $DIR/d26-3<br>
}<br>
run_test 26e &quot;unlink multiple component recursive symlink&quot;&quot;<=
br>
<br>
# recursive symlinks (bug 7022)<br>
test_26f() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/$tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/$tdir/$tfile =C2=A0 =C2=A0 =C2=A0 =
=C2=A0|| error &quot;mkdir $DIR/$tdir/$tfile failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR/$tdir/$tfile =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 || error &quot;cd $DIR/$tdir/$tfile failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p lndir/bar1 =C2=A0 =C2=A0 =C2=A0|| erro=
r &quot;mkdir lndir/bar1 failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $tfile =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 || error &quot;mkdir $tfile failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $tfile =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0|| error &quot;cd $tfile failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s .. dotdot =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0|| error &quot;ln dotdot failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s dotdot/lndir lndir || error &quot;ln lndi=
r failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR/$tdir =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 || error &quot;cd $DIR/$tdir failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0output=3D`ls $tfile/$tfile/lndir/bar1`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ &quot;$output&quot;&quot; bar1 ] &amp;&amp; e=
rror &quot;unexpected output&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -r $tfile =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 || error &quot;rm $tfile failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/$tfile || error &quot;$tfile=
 not gone&quot;<br>
}<br>
run_test 26f &quot;rm -r of a directory which has recursive symlink&quot;&q=
uot;<br>
<br>
# createtest also checks that device nodes are created and<br>
# then visible correctly (#2091)<br>
test_28() { # bug 2091<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d28<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CREATETEST $DIR/d28/ct || error<br>
}<br>
run_test 28 &quot;create/mknod/mkdir with bad file types&quot;&quot;<br>
<br>
test_30() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cp `which ls` $DIR || cp /bin/ls $DIR<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$DIR/ls /<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $DIR/ls<br>
}<br>
run_test 30 &quot;run binary from Lustre (execve)&quot;&quot;<br>
<br>
test_31a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$OPENUNLINK $DIR/f31 $DIR/f31 || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/f31 || error<br>
}<br>
run_test 31a &quot;open-unlink file&quot;&quot;<br>
<br>
test_31b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/f31 || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln $DIR/f31 $DIR/f31b || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0multiop $DIR/f31b Ouc || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/f31 || error<br>
}<br>
run_test 31b &quot;unlink file with multiple links while open&quot;&quot;<b=
r>
<br>
test_31c() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/f31 || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln $DIR/f31 $DIR/f31c || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0multiop_bg_pause $DIR/f31 O_uc || return 1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0MULTIPID=3D$!<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0multiop $DIR/f31c Ouc<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0kill -USR1 $MULTIPID<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0wait $MULTIPID<br>
}<br>
run_test 31c &quot;open-unlink file with multiple links&quot;&quot;<br>
<br>
test_31d() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0opendirunlink $DIR/d31d $DIR/d31d || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -a $DIR/d31d || error<br>
}<br>
run_test 31d &quot;remove of open directory&quot;&quot;<br>
<br>
test_31e() { # bug 2904<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0check_kernel_version 34 || return 0<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0openfilleddirunlink $DIR/d31e || error<br>
}<br>
run_test 31e &quot;remove of open non-empty directory&quot;&quot;<br>
<br>
test_31f() { # bug 4554<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0set -vx<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d31f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$SETSTRIPE $DIR/d31f -s 1048576 -c 1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cp /etc/hosts $DIR/d31f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -l $DIR/d31f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0multiop_bg_pause $DIR/d31f D_c || return 1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0MULTIPID=3D$!<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -rv $DIR/d31f || error &quot;first of $DIR/d=
31f&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d31f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$SETSTRIPE $DIR/d31f -s 1048576 -c 1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cp /etc/hosts $DIR/d31f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -l $DIR/d31f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$DIR/d31f/hosts<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0multiop_bg_pause $DIR/d31f D_c || return 1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0MULTIPID2=3D$!<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0kill -USR1 $MULTIPID || error &quot;first opend=
ir $MULTIPID not running&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0wait $MULTIPID || error &quot;first opendir $MU=
LTIPID failed&quot;<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0sleep 6<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0kill -USR1 $MULTIPID2 || error &quot;second ope=
ndir $MULTIPID not running&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0wait $MULTIPID2 || error &quot;second opendir $=
MULTIPID2 failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0set +vx<br>
}<br>
run_test 31f &quot;remove of open directory with open-unlink file&quot;&quo=
t;<br>
<br>
test_31g() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;-- cross directory link --&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d31g{a,b}<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d31ga/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln $DIR/d31ga/f $DIR/d31gb/g<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/d31ga/f || error &quot;=
source&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ `stat -c%h $DIR/d31ga/f`&quot; &#39;2&#39; ] =
|| error &quot;source nlink&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/d31gb/g || error &quot;=
target&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ `stat -c%h $DIR/d31gb/g`&quot; &#39;2&#39; ] =
|| error &quot;target nlink&quot;<br>
}<br>
run_test 31g &quot;cross directory link=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D&quot;<br>
<br>
test_31h() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;-- cross directory link --&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d31h<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d31h/dir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d31h/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln $DIR/d31h/f $DIR/d31h/dir/g<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/d31h/f || error &quot;s=
ource&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ `stat -c%h $DIR/d31h/f`&quot; &#39;2&#39; ] |=
| error &quot;source nlink&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/d31h/dir/g || error &qu=
ot;target&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ `stat -c%h $DIR/d31h/dir/g`&quot; &#39;2&#39;=
 ] || error &quot;target nlink&quot;<br>
}<br>
run_test 31h &quot;cross directory link under child=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D&quot;<br>
<br>
test_31i() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;-- cross directory link --&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d31i<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d31i/dir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d31i/dir/f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln $DIR/d31i/dir/f $DIR/d31i/g<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/d31i/dir/f || error &qu=
ot;source&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ `stat -c%h $DIR/d31i/dir/f`&quot; &#39;2&#39;=
 ] || error &quot;source nlink&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/d31i/g || error &quot;t=
arget&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ `stat -c%h $DIR/d31i/g`&quot; &#39;2&#39; ] |=
| error &quot;target nlink&quot;<br>
}<br>
run_test 31i &quot;cross directory link under parent=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D&quot;<br>
<br>
<br>
test_31j() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d31j<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d31j/dir1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln $DIR/d31j/dir1 $DIR/d31j/dir2 &amp;&amp; err=
or &quot;ln for dir&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0link $DIR/d31j/dir1 $DIR/d31j/dir3 &amp;&amp; e=
rror &quot;link for dir&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlink $DIR/d31j/dir1 $DIR/d31j/dir4 &amp;&amp; =
error &quot;mlink for dir&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlink $DIR/d31j/dir1 $DIR/d31j/dir1 &amp;&amp; =
error &quot;mlink to the same dir&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0<br>
}<br>
run_test 31j &quot;link for directory=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D&quot;<br>
<br>
<br>
test_31k() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d31k<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d31k/s<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d31k/exist<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlink $DIR/d31k/s $DIR/d31k/t || error &quot;ml=
ink&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlink $DIR/d31k/s $DIR/d31k/exist &amp;&amp; er=
ror &quot;mlink to exist file&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlink $DIR/d31k/s $DIR/d31k/s &amp;&amp; error =
&quot;mlink to the same file&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlink $DIR/d31k/s $DIR/d31k &amp;&amp; error &q=
uot;mlink to parent dir&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlink $DIR/d31k $DIR/d31k/s &amp;&amp; error &q=
uot;mlink parent dir to target&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlink $DIR/d31k/not-exist $DIR/d31k/foo &amp;&a=
mp; error &quot;mlink non-existing to new&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlink $DIR/d31k/not-exist $DIR/d31k/s &amp;&amp=
; error &quot;mlink non-existing to exist&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0<br>
}<br>
run_test 31k &quot;link to file: the same, non-existing, dir=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D&quot;<br>
<br>
test_31m() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d31m<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d31m/s<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d31m2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d31m2/exist<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlink $DIR/d31m/s $DIR/d31m2/t || error &quot;m=
link&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlink $DIR/d31m/s $DIR/d31m2/exist &amp;&amp; e=
rror &quot;mlink to exist file&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlink $DIR/d31m/s $DIR/d31m2 &amp;&amp; error &=
quot;mlink to parent dir&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlink $DIR/d31m2 $DIR/d31m/s &amp;&amp; error &=
quot;mlink parent dir to target&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlink $DIR/d31m/not-exist $DIR/d31m2/foo &amp;&=
amp; error &quot;mlink non-existing to new&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mlink $DIR/d31m/not-exist $DIR/d31m2/s &amp;&am=
p; error &quot;mlink non-existing to exist&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0<br>
}<br>
run_test 31m &quot;link to file: the same, non-existing, dir=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D&quot;<br>
<br>
test_32a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;=3D=3D more mountpoints and symlinks=
&quot;&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -e $DIR/d32a ] &amp;&amp; rm -fr $DIR/d32a<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32a/ext2-mountpoint<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mount -t ext2 -o loop $EXT2_DEV $DIR/d32a/ext2-=
mountpoint || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/d32a/ext2-mountpoint/.. =
|| error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$UMOUNT $DIR/d32a/ext2-mountpoint || error<br>
}<br>
run_test 32a &quot;stat d32a/ext2-mountpoint/..&quot;&quot;<br>
<br>
test_32b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -e $DIR/d32b ] &amp;&amp; rm -fr $DIR/d32b<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32b/ext2-mountpoint<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mount -t ext2 -o loop $EXT2_DEV $DIR/d32b/ext2-=
mountpoint || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -al $DIR/d32b/ext2-mountpoint/.. || error<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$UMOUNT $DIR/d32b/ext2-mountpoint || error<br>
}<br>
run_test 32b &quot;open d32b/ext2-mountpoint/..&quot;&quot;<br>
<br>
test_32c() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -e $DIR/d32c ] &amp;&amp; rm -fr $DIR/d32c<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32c/ext2-mountpoint<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mount -t ext2 -o loop $EXT2_DEV $DIR/d32c/ext2-=
mountpoint || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32c/d2/test_dir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir $DIR/d32c/ext2-mountpoint/../=
d2/test_dir || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$UMOUNT $DIR/d32c/ext2-mountpoint || error<br>
}<br>
run_test 32c &quot;stat d32c/ext2-mountpoint/../d2/test_dir&quot;&quot;<br>
<br>
test_32d() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -e $DIR/d32d ] &amp;&amp; rm -fr $DIR/d32d<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32d/ext2-mountpoint<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mount -t ext2 -o loop $EXT2_DEV $DIR/d32d/ext2-=
mountpoint || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32d/d2/test_dir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -al $DIR/d32d/ext2-mountpoint/../d2/test_dir=
 || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$UMOUNT $DIR/d32d/ext2-mountpoint || error<br>
}<br>
run_test 32d &quot;open d32d/ext2-mountpoint/../d2/test_dir&quot;&quot;<br>
<br>
test_32e() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -e $DIR/d32e ] &amp;&amp; rm -fr $DIR/d32e<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32e/tmp<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0TMP_DIR=3D$DIR/d32e/tmp<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $DIR/d32e $TMP_DIR/symlink11<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $TMP_DIR/symlink11 $TMP_DIR/../symlink01<=
br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t link $DIR/d32e/tmp/symlink11 || e=
rror<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t link $DIR/d32e/symlink01 || error=
<br>
}<br>
run_test 32e &quot;stat d32e/symlink-&gt;tmp/symlink-&gt;lustre-subdir&quot=
;&quot;<br>
<br>
test_32f() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -e $DIR/d32f ] &amp;&amp; rm -fr $DIR/d32f<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32f/tmp<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0TMP_DIR=3D$DIR/d32f/tmp<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $DIR/d32f $TMP_DIR/symlink11<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $TMP_DIR/symlink11 $TMP_DIR/../symlink01<=
br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls $DIR/d32f/tmp/symlink11 =C2=A0|| error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls $DIR/d32f/symlink01 || error<br>
}<br>
run_test 32f &quot;open d32f/symlink-&gt;tmp/symlink-&gt;lustre-subdir&quot=
;&quot;<br>
<br>
test_32g() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0TMP_DIR=3D$DIR/$tdir/tmp<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $TMP_DIR $DIR/${tdir}2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $DIR/${tdir}2 $TMP_DIR/symlink12<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $TMP_DIR/symlink12 $TMP_DIR/../symlink02<=
br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t link $TMP_DIR/symlink12 || error<=
br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t link $DIR/$tdir/symlink02 || erro=
r<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir -f $TMP_DIR/symlink12 || erro=
r<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t dir -f $DIR/$tdir/symlink02 || er=
ror<br>
}<br>
run_test 32g &quot;stat d32g/symlink-&gt;tmp/symlink-&gt;lustre-subdir/${td=
ir}2&quot;<br>
<br>
test_32h() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -fr $DIR/$tdir $DIR/${tdir}2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0TMP_DIR=3D$DIR/$tdir/tmp<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $TMP_DIR $DIR/${tdir}2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $DIR/${tdir}2 $TMP_DIR/symlink12<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $TMP_DIR/symlink12 $TMP_DIR/../symlink02<=
br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls $TMP_DIR/symlink12 || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls $DIR/$tdir/symlink02 =C2=A0|| error<br>
}<br>
run_test 32h &quot;open d32h/symlink-&gt;tmp/symlink-&gt;lustre-subdir/${td=
ir}2&quot;<br>
<br>
test_32i() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -e $DIR/d32i ] &amp;&amp; rm -fr $DIR/d32i<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32i/ext2-mountpoint<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mount -t ext2 -o loop $EXT2_DEV $DIR/d32i/ext2-=
mountpoint || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d32i/test_file<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/d32i/ext2-mountpoint/..=
/test_file || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$UMOUNT $DIR/d32i/ext2-mountpoint || error<br>
}<br>
run_test 32i &quot;stat d32i/ext2-mountpoint/../test_file&quot;&quot;<br>
<br>
test_32j() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -e $DIR/d32j ] &amp;&amp; rm -fr $DIR/d32j<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32j/ext2-mountpoint<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mount -t ext2 -o loop $EXT2_DEV $DIR/d32j/ext2-=
mountpoint || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d32j/test_file<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cat $DIR/d32j/ext2-mountpoint/../test_file || e=
rror<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$UMOUNT $DIR/d32j/ext2-mountpoint || error<br>
}<br>
run_test 32j &quot;open d32j/ext2-mountpoint/../test_file&quot;&quot;<br>
<br>
test_32k() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -fr $DIR/d32k<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32k/ext2-mountpoint<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mount -t ext2 -o loop $EXT2_DEV $DIR/d32k/ext2-=
mountpoint<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32k/d2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d32k/d2/test_file || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file $DIR/d32k/ext2-mountpoint/..=
/d2/test_file || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$UMOUNT $DIR/d32k/ext2-mountpoint || error<br>
}<br>
run_test 32k &quot;stat d32k/ext2-mountpoint/../d2/test_file&quot;&quot;<br=
>
<br>
test_32l() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -fr $DIR/d32l<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32l/ext2-mountpoint<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mount -t ext2 -o loop $EXT2_DEV $DIR/d32l/ext2-=
mountpoint || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32l/d2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d32l/d2/test_file<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cat =C2=A0$DIR/d32l/ext2-mountpoint/../d2/test_=
file || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$UMOUNT $DIR/d32l/ext2-mountpoint || error<br>
}<br>
run_test 32l &quot;open d32l/ext2-mountpoint/../d2/test_file&quot;&quot;<br=
>
<br>
test_32m() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -fr $DIR/d32m<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32m/tmp<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0TMP_DIR=3D$DIR/d32m/tmp<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $DIR $TMP_DIR/symlink11<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $TMP_DIR/symlink11 $TMP_DIR/../symlink01<=
br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t link $DIR/d32m/tmp/symlink11 || e=
rror<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t link $DIR/d32m/symlink01 || error=
<br>
}<br>
run_test 32m &quot;stat d32m/symlink-&gt;tmp/symlink-&gt;lustre-root&quot;&=
quot;<br>
<br>
test_32n() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -fr $DIR/d32n<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32n/tmp<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0TMP_DIR=3D$DIR/d32n/tmp<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $DIR $TMP_DIR/symlink11<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $TMP_DIR/symlink11 $TMP_DIR/../symlink01<=
br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -l $DIR/d32n/tmp/symlink11 =C2=A0|| error<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -l $DIR/d32n/symlink01 || error<br>
}<br>
run_test 32n &quot;open d32n/symlink-&gt;tmp/symlink-&gt;lustre-root&quot;&=
quot;<br>
<br>
test_32o() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -fr $DIR/d32o $DIR/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32o/tmp<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0TMP_DIR=3D$DIR/d32o/tmp<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $DIR/$tfile $TMP_DIR/symlink12<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $TMP_DIR/symlink12 $TMP_DIR/../symlink02<=
br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t link $DIR/d32o/tmp/symlink12 || e=
rror<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t link $DIR/d32o/symlink02 || error=
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file -f $DIR/d32o/tmp/symlink12 |=
| error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file -f $DIR/d32o/symlink02 || er=
ror<br>
}<br>
run_test 32o &quot;stat d32o/symlink-&gt;tmp/symlink-&gt;lustre-root/$tfile=
&quot;<br>
<br>
test_32p() {<br>
 =C2=A0 =C2=A0log 32p_1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -fr $DIR/d32p<br>
 =C2=A0 =C2=A0log 32p_2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/$tfile<br>
 =C2=A0 =C2=A0log 32p_3<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/$tfile<br>
 =C2=A0 =C2=A0log 32p_4<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32p/tmp<br>
 =C2=A0 =C2=A0log 32p_5<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0TMP_DIR=3D$DIR/d32p/tmp<br>
 =C2=A0 =C2=A0log 32p_6<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $DIR/$tfile $TMP_DIR/symlink12<br>
 =C2=A0 =C2=A0log 32p_7<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s $TMP_DIR/symlink12 $TMP_DIR/../symlink02<=
br>
 =C2=A0 =C2=A0log 32p_8<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cat $DIR/d32p/tmp/symlink12 || error<br>
 =C2=A0 =C2=A0log 32p_9<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cat $DIR/d32p/symlink02 || error<br>
 =C2=A0 =C2=A0log 32p_10<br>
}<br>
run_test 32p &quot;open d32p/symlink-&gt;tmp/symlink-&gt;lustre-root/$tfile=
&quot;<br>
<br>
test_32q() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -e $DIR/d32q ] &amp;&amp; rm -fr $DIR/d32q<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32q<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d32q/under_the_mount<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mount -t ext2 -o loop $EXT2_DEV $DIR/d32q<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls $DIR/d32q/under_the_mount &amp;&amp; error |=
| true<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$UMOUNT $DIR/d32q || error<br>
}<br>
run_test 32q &quot;stat follows mountpoints in Lustre (should return error)=
&quot;<br>
<br>
test_32r() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -e $DIR/d32r ] &amp;&amp; rm -fr $DIR/d32r<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d32r<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d32r/under_the_mount<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mount -t ext2 -o loop $EXT2_DEV $DIR/d32r<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls $DIR/d32r | grep -q under_the_mount &amp;&am=
p; error || true<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$UMOUNT $DIR/d32r || error<br>
}<br>
run_test 32r &quot;opendir follows mountpoints in Lustre (should return err=
or)&quot;<br>
<br>
test_33() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 444 $DIR/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chown $RUNAS_ID $DIR/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0log 33_1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS $OPENFILE -f O_RDWR $DIR/$tfile &amp;&am=
p; error || true<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0log 33_2<br>
}<br>
run_test 33 &quot;write file with mode 444 (should return error)&quot;&quot=
;<br>
<br>
test_33a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -fr $DIR/d33<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d33<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chown $RUNAS_ID $DIR/d33<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS $OPENFILE -f O_RDWR:O_CREAT -m 0444 $DIR=
/d33/f33|| error &quot;create&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS $OPENFILE -f O_RDWR:O_CREAT -m 0444 $DIR=
/d33/f33 &amp;&amp; \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;open RD=
WR&quot; || true<br>
}<br>
run_test 33a &quot;test open file(mode=3D0444) with O_RDWR (should return e=
rror)&quot;<br>
<br>
test_33b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -fr $DIR/d33<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d33<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chown $RUNAS_ID $DIR/d33<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS $OPENFILE -f 1286739555 $DIR/d33/f33 &am=
p;&amp; error &quot;create&quot; || true<br>
}<br>
run_test 33b &quot;test open file with malformed flags (No panic and return=
 error)&quot;<br>
<br>
TEST_34_SIZE=3D${TEST_34_SIZE:-2000000000000}<br>
test_34a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/f34<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$MCREATE $DIR/f34 || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$TRUNCATE $DIR/f34 $TEST_34_SIZE || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error<b=
r>
}<br>
run_test 34a &quot;truncate file that has not been opened&quot;&quot;<br>
<br>
test_34b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ ! -f $DIR/f34 ] &amp;&amp; test_34a<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error<b=
r>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$OPENFILE -f O_RDONLY $DIR/f34<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error<b=
r>
}<br>
run_test 34b &quot;O_RDONLY opening file doesn&#39;t create objects&quot;&q=
uot;<br>
<br>
test_34c() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ ! -f $DIR/f34 ] &amp;&amp; test_34a<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error<b=
r>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$OPENFILE -f O_RDWR $DIR/f34<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error<b=
r>
}<br>
run_test 34c &quot;O_RDWR opening file-with-size works&quot;&quot;<br>
<br>
test_34d() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ ! -f $DIR/f34 ] &amp;&amp; test_34a<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D/dev/zero of=3D$DIR/f34 conv=3Dnotrunc =
bs=3D4k count=3D1 || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -s $TEST_34_SIZE $DIR/f34 || error<b=
r>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $DIR/f34<br>
}<br>
run_test 34d &quot;write to sparse file&quot;&quot;<br>
<br>
test_34e() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/f34e<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$MCREATE $DIR/f34e || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$TRUNCATE $DIR/f34e 1000 || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -s 1000 $DIR/f34e || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$OPENFILE -f O_RDWR $DIR/f34e<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -s 1000 $DIR/f34e || error<br>
}<br>
run_test 34e &quot;create objects, some with size and some without&quot;&qu=
ot;<br>
<br>
test_34f() { # bug 6242, 6243<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0SIZE34F=3D48000<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/f34f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$MCREATE $DIR/f34f || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$TRUNCATE $DIR/f34f $SIZE34F || error &quot;tru=
ncating $DIR/f3f to $SIZE34F&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D$DIR/f34f of=3D$TMP/f34f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -s $SIZE34F $TMP/f34f || error &quot=
;$TMP/f34f not $SIZE34F bytes&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D/dev/zero of=3D$TMP/f34fzero bs=3D$SIZE=
34F count=3D1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cmp $DIR/f34f $TMP/f34fzero || error &quot;$DIR=
/f34f not all zero&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cmp $TMP/f34f $TMP/f34fzero || error &quot;$TMP=
/f34f not all zero&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $TMP/f34f $TMP/f34fzero $DIR/f34f<br>
}<br>
run_test 34f &quot;read from a file with no objects until EOF&quot;&quot;<b=
r>
<br>
test_35a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cp /bin/sh $DIR/f35a<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 444 $DIR/f35a<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chown $RUNAS_ID $DIR/f35a<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS $DIR/f35a &amp;&amp; error || true<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $DIR/f35a<br>
}<br>
run_test 35a &quot;exec file with mode 444 (should return and not leak)&quo=
t;&quot;<br>
<br>
test_36a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/f36<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0utime $DIR/f36 || error<br>
}<br>
run_test 36a &quot;MDS utime check (mknod, utime)&quot;&quot;<br>
<br>
test_36b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;&quot; &gt; $DIR/f36<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0utime $DIR/f36 || error<br>
}<br>
run_test 36b &quot;OST utime check (open, utime)&quot;&quot;<br>
<br>
test_36c() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/d36/f36<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d36<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chown $RUNAS_ID $DIR/d36<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS utime $DIR/d36/f36 || error<br>
}<br>
run_test 36c &quot;non-root MDS utime check (mknod, utime)&quot;&quot;<br>
<br>
test_36d() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ ! -d $DIR/d36 ] &amp;&amp; test_36c<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;&quot; &gt; $DIR/d36/f36<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS utime $DIR/d36/f36 || error<br>
}<br>
run_test 36d &quot;non-root OST utime check (open, utime)&quot;&quot;<br>
<br>
test_36e() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $RUNAS_ID -eq $UID ] &amp;&amp; skip &quot;RU=
NAS_ID&quot; UID =3D $UID -- skipping&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/$tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/$tdir/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS utime $DIR/$tdir/$tfile &amp;&amp; \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;utime w=
orked, expected failure&quot; || true<br>
}<br>
run_test 36e &quot;utime on non-owned file (should return error)&quot;&quot=
;<br>
<br>
test_37() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/$tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo f &gt; $DIR/$tdir/fbugfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mount -t ext2 -o loop $EXT2_DEV $DIR/$tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls $DIR/$tdir | grep &quot;\&lt;fbugfile\&gt;&q=
uot; &amp;&amp; error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$UMOUNT $DIR/$tdir || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/$tdir/fbugfile || error<br>
}<br>
run_test 37 &quot;ls a mounted file system to check old content&quot;&quot;=
<br>
<br>
test_38() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local file=3D$DIR/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $file<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0openfile -f O_DIRECTORY $file<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local RC=3D$?<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local ENOTDIR=3D20<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $RC -eq 0 ] &amp;&amp; error &quot;opened fil=
e $file with O_DIRECTORY&quot; || true<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $RC -eq $ENOTDIR ] || error &quot;error $RC s=
hould be ENOTDIR ($ENOTDIR)&quot;<br>
}<br>
run_test 38 &quot;open a regular file with O_DIRECTORY should return -ENOTD=
IR&quot;&quot;<br>
<br>
test_39() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/${tfile}2<br>
# =C2=A0 =C2=A0 =C2=A0 ls -l =C2=A0$DIR/$tfile $DIR/${tfile}2<br>
# =C2=A0 =C2=A0 =C2=A0 ls -lu =C2=A0$DIR/$tfile $DIR/${tfile}2<br>
# =C2=A0 =C2=A0 =C2=A0 ls -lc =C2=A0$DIR/$tfile $DIR/${tfile}2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0sleep 2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$OPENFILE -f O_CREAT:O_TRUNC:O_WRONLY $DIR/${tf=
ile}2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ ! $DIR/${tfile}2 -nt $DIR/$tfile ]; then<b=
r>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;mtime&qu=
ot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -l =C2=A0$DIR/$t=
file $DIR/${tfile}2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;atime&qu=
ot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -lu =C2=A0$DIR/$=
tfile $DIR/${tfile}2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;ctime&qu=
ot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -lc =C2=A0$DIR/$=
tfile $DIR/${tfile}2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;O_TRUNC=
 didn&#39;t change timestamps&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
}<br>
run_test 39 &quot;mtime changed on create&quot;&quot;<br>
<br>
test_40() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D/dev/zero of=3D$DIR/f40 bs=3D4096 count=
=3D1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS $OPENFILE -f O_WRONLY:O_TRUNC $DIR/f40 &=
amp;&amp; error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$CHECKSTAT -t file -s 4096 $DIR/f40 || error<br=
>
}<br>
run_test 40 &quot;failed open(O_TRUNC) doesn&#39;t truncate&quot;&quot;<br>
<br>
test_43() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/$tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cp -p /bin/ls $DIR/$tdir/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0multiop $DIR/$tdir/$tfile Ow_c &amp;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0pid=3D$!<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# give multiop a chance to open<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0sleep 1<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$DIR/$tdir/$tfile &amp;&amp; error || true<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0kill -USR1 $pid<br>
}<br>
run_test 43 &quot;execution of file opened for write should return -ETXTBSY=
&quot;<br>
<br>
test_43a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d43<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cp -p `which multiop` $DIR/d43/multiop || cp -p=
 multiop $DIR/d43/multiop<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0MULTIOP_PROG=3D$DIR/d43/multiop multiop_bg_paus=
e $TMP/test43.junk O_c || return 1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0MULTIOP_PID=3D$!<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0multiop $DIR/d43/multiop Oc &amp;&amp; error &q=
uot;expected error, got success&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0kill -USR1 $MULTIOP_PID || return 2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0wait $MULTIOP_PID || return 3<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $TMP/test43.junk<br>
}<br>
run_test 43a &quot;open(RDWR) of file being executed should return -ETXTBSY=
&quot;<br>
<br>
test_43b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d43<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cp -p `which multiop` $DIR/d43/multiop || cp -p=
 multiop $DIR/d43/multiop<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0MULTIOP_PROG=3D$DIR/d43/multiop multiop_bg_paus=
e $TMP/test43.junk O_c || return 1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0MULTIOP_PID=3D$!<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0truncate $DIR/d43/multiop 0 &amp;&amp; error &q=
uot;expected error, got success&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0kill -USR1 $MULTIOP_PID || return 2<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0wait $MULTIOP_PID || return 3<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $TMP/test43.junk<br>
}<br>
run_test 43b &quot;truncate of file being executed should return -ETXTBSY&q=
uot;<br>
<br>
page_size() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0getconf PAGE_SIZE<br>
}<br>
<br>
test_48a() { # bug 2399<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d48a<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR/d48a<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mv $DIR/d48a $DIR/d48.new || error &quot;move d=
irectory failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d48a || error &quot;recreate directo=
ry failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch foo || error &quot;&#39;touch foo&#39; fa=
iled after recreating cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir bar || error &quot;&#39;mkdir foo&#39; fa=
iled after recreating cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch .foo || error &quot;&#39;touch .foo&#39; =
failed after recreating cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir .bar || error &quot;&#39;mkdir .foo&#39; =
failed after recreating cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls . &gt; /dev/null || error &quot;&#39;ls .&#3=
9; failed after recreating cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls .. &gt; /dev/null || error &quot;&#39;ls ..&=
#39; failed after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd . || error &quot;&#39;cd .&#39; failed after=
 recreating cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir . &amp;&amp; error &quot;&#39;mkdir .&#39=
; worked after recreating cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rmdir . &amp;&amp; error &quot;&#39;rmdir .&#39=
; worked after recreating cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s . baz || error &quot;&#39;ln -s .&#39; fa=
iled after recreating cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd .. || error &quot;&#39;cd ..&#39; failed aft=
er recreating cwd&quot;<br>
}<br>
run_test 48a &quot;Access renamed working dir (should return errors)=3D&quo=
t;<br>
<br>
test_48b() { # bug 2399<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d48b<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR/d48b<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rmdir $DIR/d48b || error &quot;remove cwd $DIR/=
d48b failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch foo &amp;&amp; error &quot;&#39;touch foo=
&#39; worked after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir foo &amp;&amp; error &quot;&#39;mkdir foo=
&#39; worked after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch .foo &amp;&amp; error &quot;&#39;touch .f=
oo&#39; worked after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir .foo &amp;&amp; error &quot;&#39;mkdir .f=
oo&#39; worked after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls . &gt; /dev/null &amp;&amp; error &quot;&#39=
;ls .&#39; worked after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls .. &gt; /dev/null || error &quot;&#39;ls ..&=
#39; failed after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir . &amp;&amp; error &quot;&#39;mkdir .&#39=
; worked after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rmdir . &amp;&amp; error &quot;&#39;rmdir .&#39=
; worked after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s . foo &amp;&amp; error &quot;&#39;ln -s .=
&#39; worked after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd .. || echo &quot;&#39;cd ..&#39; failed afte=
r removing cwd `pwd`&quot; =C2=A0#bug 3517<br>
}<br>
run_test 48b &quot;Access removed working dir (should return errors)=3D&quo=
t;<br>
<br>
test_48c() { # bug 2350<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d48c/dir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR/d48c/dir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rmdir $DIR/d48c/dir || error &quot;remove cwd $=
DIR/d48c/dir failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch foo &amp;&amp; error &quot;&#39;touch foo=
&#39; worked after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir foo &amp;&amp; error &quot;&#39;mkdir foo=
&#39; worked after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch .foo &amp;&amp; error &quot;&#39;touch .f=
oo&#39; worked after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir .foo &amp;&amp; error &quot;&#39;mkdir .f=
oo&#39; worked after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls . &amp;&amp; error &quot;&#39;ls .&#39; work=
ed after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls .. || error &quot;&#39;ls ..&#39; failed aft=
er removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir . &amp;&amp; error &quot;&#39;mkdir .&#39=
; worked after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rmdir . &amp;&amp; error &quot;&#39;rmdir .&#39=
; worked after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s . foo &amp;&amp; error &quot;&#39;ln -s .=
&#39; worked after removing cwd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd .. || echo &quot;&#39;cd ..&#39; failed afte=
r removing cwd `pwd`&quot; #bug 3415<br>
}<br>
run_test 48c &quot;Access removed working subdir (should return errors)&quo=
t;<br>
<br>
test_48d() { # bug 2350<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d48d/dir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR/d48d/dir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rmdir $DIR/d48d/dir || error &quot;remove cwd $=
DIR/d48d/dir failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rmdir $DIR/d48d || error &quot;remove parent $D=
IR/d48d failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch foo &amp;&amp; error &quot;&#39;touch foo=
&#39; worked after removing parent&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir foo &amp;&amp; error &quot;&#39;mkdir foo=
&#39; worked after removing parent&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch .foo &amp;&amp; error &quot;&#39;touch .f=
oo&#39; worked after removing parent&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir .foo &amp;&amp; error &quot;&#39;mkdir .f=
oo&#39; worked after removing parent&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls . &amp;&amp; error &quot;&#39;ls .&#39; work=
ed after removing parent&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls .. &amp;&amp; error &quot;&#39;ls ..&#39; wo=
rked after removing parent&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir . &amp;&amp; error &quot;&#39;mkdir .&#39=
; worked after removing parent&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rmdir . &amp;&amp; error &quot;&#39;rmdir .&#39=
; worked after removing parent&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s . foo &amp;&amp; error &quot;&#39;ln -s .=
&#39; worked after removing parent&quot;<br>
}<br>
run_test 48d &quot;Access removed parent subdir (should return errors)&quot=
;<br>
<br>
test_48e() { # bug 4134<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d48e/dir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR/d48e/dir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rmdir $DIR/d48e/dir || error &quot;remove cwd $=
DIR/d48e/dir failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rmdir $DIR/d48e || error &quot;remove parent $D=
IR/d48e failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d48e || error &quot;&#39;touch $DIR/=
d48e&#39; failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod +x $DIR/d48e || error &quot;&#39;chmod +x=
 $DIR/d48e&#39; failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# On a buggy kernel addition of &quot;touch foo=
&quot; after cd .. will<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# produce kernel oops in lookup_hash_it<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch ../foo &amp;&amp; error &quot;&#39;cd ..&=
#39; worked after recreate parent&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $DIR/d48e || error &quot;rm &#39;$DIR/d48e&#=
39; failed&quot;<br>
}<br>
run_test 48e &quot;Access to recreated parent subdir (should return errors)=
&quot;<br>
<br>
test_50() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# bug 1485<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d50<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR/d50<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls /proc/$$/cwd || error<br>
}<br>
run_test 50 &quot;special situations: /proc symlinks &quot;&quot;<br>
<br>
test_51a() { =C2=A0 =C2=A0# was test_51<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# bug 1516 - create an empty entry right after =
&quot;..&quot; then split dir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d51<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d51/foo<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$MCREATE $DIR/d51/bar<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $DIR/d51/foo<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0createmany -m $DIR/d51/longfile 201<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0FNUM=3D202<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0while [ `ls -sd $DIR/d51 | awk &#39;{ print $1 =
}&#39;` -eq 4 ]; do<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$MCREATE $DIR/d51/l=
ongfile$FNUM<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FNUM=3D$(($FNUM + 1=
))<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo -n &quot;+&quo=
t;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0done<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -l $DIR/d51 &gt; /dev/null || error<br>
}<br>
run_test 51a &quot;special situations: split htree with empty entry&quot;&q=
uot;<br>
<br>
export NUMTEST=3D70000<br>
test_51b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0NUMFREE=3D`df -i -P $DIR | tail -n 1 | awk &#39=
;{ print $4 }&#39;`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $NUMFREE -lt 21000 ] &amp;&amp; \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0skip &quot;not enou=
gh free inodes ($NUMFREE)&quot; &amp;&amp; \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0check_kernel_version 40 || NUMTEST=3D31000<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $NUMFREE -lt $NUMTEST ] &amp;&amp; NUMTEST=3D=
$(($NUMFREE - 50))<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d51b<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0createmany -d $DIR/d51b/t- $NUMTEST<br>
}<br>
run_test 51b &quot;mkdir .../t-0 --- .../t-$NUMTEST&quot;&quot;<br>
<br>
test_51c() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ ! -d $DIR/d51b ] &amp;&amp; skip &quot;$DIR/5=
1b missing&quot; &amp;&amp; \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0unlinkmany -d $DIR/d51b/t- $NUMTEST<br>
}<br>
run_test 51c &quot;rmdir .../t-0 --- .../t-$NUMTEST&quot;&quot;<br>
<br>
test_52a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -f $DIR/d52a/foo ] &amp;&amp; chattr -a $DIR/=
d52a/foo<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d52a<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d52a/foo<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chattr&quot;a $DIR/d52a/foo || error &quot;chat=
tr =3Da failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo bar &gt;&gt; $DIR/d52a/foo || error &quot;=
append bar failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cp /etc/hosts $DIR/d52a/foo &amp;&amp; error &q=
uot;cp worked&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/d52a/foo 2&gt;/dev/null &amp;&amp; e=
rror &quot;rm worked&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0link $DIR/d52a/foo $DIR/d52a/foo_link 2&gt;/dev=
/null &amp;&amp; error &quot;link worked&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo foo &gt;&gt; $DIR/d52a/foo || error &quot;=
append foo failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mrename $DIR/d52a/foo $DIR/d52a/foo_ren &amp;&a=
mp; error &quot;rename worked&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0lsattr $DIR/d52a/foo | egrep -q &quot;^-+a-+ $D=
IR/d52a/foo&quot; || error &quot;lsattr&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chattr -a $DIR/d52a/foo || error &quot;chattr -=
a failed&quot;<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -fr $DIR/d52a || error &quot;cleanup rm fail=
ed&quot;<br>
}<br>
run_test 52a &quot;append-only flag test (should return errors)&quot;&quot;=
<br>
<br>
test_52b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -f $DIR/d52b/foo ] &amp;&amp; chattr -i $DIR/=
d52b/foo<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d52b<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d52b/foo<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chattr&quot;i $DIR/d52b/foo || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cat test &gt; $DIR/d52b/foo &amp;&amp; error<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cp /etc/hosts $DIR/d52b/foo &amp;&amp; error<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/d52b/foo 2&gt;/dev/null &amp;&amp; e=
rror<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0link $DIR/d52b/foo $DIR/d52b/foo_link 2&gt;/dev=
/null &amp;&amp; error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo foo &gt;&gt; $DIR/d52b/foo &amp;&amp; erro=
r<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mrename $DIR/d52b/foo $DIR/d52b/foo_ren &amp;&a=
mp; error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -f $DIR/d52b/foo ] || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -f $DIR/d52b/foo_ren ] &amp;&amp; error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0lsattr $DIR/d52b/foo | egrep -q &quot;^-+i-+ $D=
IR/d52b/foo&quot; || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chattr -i $DIR/d52b/foo || error<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -fr $DIR/d52b || error<br>
}<br>
run_test 52b &quot;immutable flag test (should return errors)&quot;&quot;<b=
r>
<br>
test_54b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0f=3D&quot;$DIR/f54b&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mknod $f c 1 3<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 0666 $f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D/dev/zero of=3D$f bs=3D`page_size` coun=
t=3D1<br>
}<br>
run_test 54b &quot;char device works in lustre&quot;&quot;<br>
<br>
find_loop_dev() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -b /dev/loop/0 ] &amp;&amp; LOOPBASE=3D/dev/l=
oop/<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -b /dev/loop0 ] &amp;&amp; LOOPBASE=3D/dev/lo=
op<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -z &quot;$LOOPBASE&quot; ] &amp;&amp; echo &q=
uot;/dev/loop/0 and /dev/loop0 gone?&quot; &amp;&amp; return<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0for i in `seq 3 7`; do<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0losetup $LOOPBASE$i=
 &gt; /dev/null 2&gt;&amp;1 &amp;&amp; continue<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LOOPDEV=3D$LOOPBASE=
$i<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LOOPNUM=3D$i<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0done<br>
}<br>
<br>
test_54c() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0tfile=3D&quot;$DIR/f54c&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0tdir=3D&quot;$DIR/d54c&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0loopdev=3D&quot;$DIR/loop54c&quot;<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0find_loop_dev<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -z &quot;$LOOPNUM&quot; ] &amp;&amp; echo &qu=
ot;couldn&#39;t find empty loop device&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mknod $loopdev b 7 $LOOPNUM<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;make a loop file system with $tfile =
on $loopdev ($LOOPNUM)...&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D/dev/zero of=3D$tfile bs=3D`page_size` =
seek=3D1024 count=3D1 &gt; /dev/null<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0losetup $loopdev $tfile || error &quot;can&#39;=
t set up $loopdev for $tfile&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkfs.ext2 $loopdev || error &quot;mke2fs on $lo=
opdev&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mount -t ext2 $loopdev $tdir || error &quot;err=
or mounting $loopdev on $tdir&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D/dev/zero of=3D$tdir/tmp bs=3D`page_siz=
e` count=3D30 || error &quot;dd write&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0df $tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D$tdir/tmp of=3D/dev/zero bs=3D`page_siz=
e` count=3D30 || error &quot;dd read&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$UMOUNT $tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0losetup -d $loopdev<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm $loopdev<br>
}<br>
run_test 54c &quot;block device works in lustre&quot;&quot;<br>
<br>
test_54d() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0f=3D&quot;$DIR/f54d&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0string=3D&quot;aaaaaa&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mknod $f p<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ &quot;$string&quot;&quot; `echo $string &gt; =
$f | cat $f` ] || error<br>
}<br>
run_test 54d &quot;fifo device works in lustre&quot;&quot;<br>
<br>
test_54e() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0check_kernel_version 46 || return 0<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0f=3D&quot;$DIR/f54e&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0string=3D&quot;aaaaaa&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cp -aL /dev/console $f<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo $string &gt; $f || error<br>
}<br>
run_test 54e &quot;console/tty device works in lustre&quot;&quot;<br>
<br>
test_61() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0f=3D&quot;$DIR/f61&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D/dev/zero of=3D$f bs=3D`page_size` coun=
t=3D1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0multiop $f OSMWUc || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0sync<br>
}<br>
run_test 61 &quot;mmap() writes don&#39;t make sync hang&quot;&quot;<br>
<br>
# bug 2543 - update blocks count on client<br>
test_66() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0COUNT=3D${COUNT:-8}<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D/dev/zero of=3D$DIR/f66 bs=3D1k count=
=3D$COUNT<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0sync; sleep 1; sync<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0BLOCKS=3D`ls -s $DIR/f66 | awk &#39;{ print $1 =
}&#39;`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $BLOCKS -ge $COUNT ] || error &quot;$DIR/f66 =
blocks $BLOCKS &lt; $COUNT&quot;<br>
}<br>
run_test 66 &quot;update inode blocks count on client&quot;&quot;<br>
<br>
LLOOP=3D<br>
cleanup_68() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0trap 0<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ ! -z &quot;$LLOOP&quot; ]; then<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if swapon -s | grep=
 -q $LLOOP; then<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0swapoff $LLOOP || error &quot;swapoff failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0losetup -d $LOOPDEV=
 || error &quot;detach failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unset LOOPDEV<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unset LLOOP<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/f68*<br>
}<br>
<br>
meminfo() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0awk &#39;($1&quot; &quot;&#39;$1&#39;:&quot;) {=
 print $2 }&#39; /proc/meminfo<br>
}<br>
<br>
swap_used() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0swapon -s | awk &#39;($1&quot; &quot;&#39;$1&#3=
9;&quot;) { print $4 }&#39;<br>
}<br>
<br>
# excercise swapping to lustre by adding a high priority swapfile entry<br>
# and then consuming memory until it is used.<br>
test_68b() { =C2=A0# was test_68<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ &quot;$UID&quot; !=3D 0 ] &amp;&amp; skip &qu=
ot;must run as root&quot; &amp;&amp; return<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0MEMTOTAL=3D`meminfo MemTotal`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0NR_BLOCKS=3D$((MEMTOTAL&gt;&gt;8))<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[[ $NR_BLOCKS -le 2048 ]] &amp;&amp; NR_BLOCKS=
=3D2048<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D/dev/zero of=3D$DIR/f68b bs=3D64k seek=
=3D$NR_BLOCKS count=3D1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkswap $DIR/f68b<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0trap cleanup_68 EXIT<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0swapon -p 32767 $LLOOP || error &quot;swapon $L=
LOOP failed&quot;<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;before: `swapon -s | grep $LLOOP`&qu=
ot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$MEMHOG $MEMTOTAL || error &quot;error allocati=
ng $MEMTOTAL kB&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;after: `swapon -s | grep $LLOOP`&quo=
t;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0SWAPUSED=3D`swap_used $LLOOP`<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cleanup_68<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $SWAPUSED -eq 0 ] &amp;&amp; echo &quot;no sw=
ap used???&quot; || true<br>
}<br>
run_test 68b &quot;support swapping to Lustre&quot;&quot;<br>
<br>
test_72() { # bug 5695 - Test that on 2.6 remove_suid works properly<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ &quot;$RUNAS_ID&quot;&quot; &quot;$UID&quot; =
] &amp;&amp; skip &quot;RUNAS_ID =3D UID =3D $UID -- skipping&quot; &amp;&a=
mp; return<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# Check that testing environment is properly se=
t up. Skip if not<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0FAIL_ON_ERROR=3Dfalse check_runas_id_ret $RUNAS=
_ID $RUNAS_ID $RUNAS || {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0skip &quot;User $RU=
NAS_ID does not exist - skipping&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/f72<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 777 $DIR/f72<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod ug+s $DIR/f72<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS dd if=3D/dev/zero of=3D$DIR/f72 bs=3D512=
 count=3D1 || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# See if we are still setuid/sgid<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0test -u $DIR/f72 -o -g $DIR/f72 &amp;&amp; erro=
r &quot;S/gid is not dropped on write&quot;<br>
}<br>
run_test 72 &quot;Test that remove suid works properly (bug5695)&quot;&quot=
;<br>
<br>
test_78() { # bug 10901<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0NSEQ=3D5<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0F78SIZE=3D$(($(awk &#39;/MemFree:/ { print $2 }=
&#39; /proc/meminfo) / 1024))<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;MemFree: $F78SIZE, Max file size: $M=
AXFREE&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0MEMTOTAL=3D$(($(awk &#39;/MemTotal:/ { print $2=
 }&#39; /proc/meminfo) / 1024))<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;MemTotal: $MEMTOTAL&quot;<br>
# reserve 256MB of memory for the kernel and other running processes,<br>
# and then take 1/2 of the remaining memory for the read/write buffers.<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ $MEMTOTAL -gt 512 ] ;then<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MEMTOTAL=3D$(((MEMT=
OTAL - 256 ) / 2))<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0# for those poor me=
mory-starved high-end clusters...<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MEMTOTAL=3D$((MEMTO=
TAL / 2))<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;Mem to use for directio: $MEMTOTAL&q=
uot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $F78SIZE -gt $MEMTOTAL ] &amp;&amp; F78SIZE=
=3D$MEMTOTAL<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $F78SIZE -gt 512 ] &amp;&amp; F78SIZE=3D512<b=
r>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $F78SIZE -gt $((MAXFREE / 1024)) ] &amp;&amp;=
 F78SIZE=3D$((MAXFREE / 1024))<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0SMALLEST=3D`df $DIR | awk &#39;{print $4}&#39; =
| tail -1`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $SMALLEST -lt 10240 ] &amp;&amp; \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0skip &quot;too smal=
l OSTSIZE, useless to run large O_DIRECT test&quot; &amp;&amp; return 0<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $F78SIZE -gt $((SMALLEST * $OSTCOUNT / 1024 -=
 80)) ] &amp;&amp; \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0F78SIZE=3D$((SMALLE=
ST * $OSTCOUNT / 1024 - 80))<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ &quot;$SLOW&quot;&quot; &quot;no&quot; ] &amp=
;&amp; NSEQ=3D1 &amp;&amp; [ $F78SIZE -gt 32 ] &amp;&amp; F78SIZE=3D32<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;File size: $F78SIZE&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$SETSTRIPE $DIR/$tfile -c $OSTCOUNT || error &q=
uot;setstripe failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0for i in `seq 1 $NSEQ`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0do<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FSIZE=3D$(($F78SIZE=
 / ($NSEQ - $i + 1)))<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo directIO rdwr =
round $i of $NSEQ<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$DIRECTIO rdwr $DIR=
/$tfile 0 $FSIZE 1048576||error &quot;rdwr failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0done<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/$tfile<br>
}<br>
run_test 78 &quot;handle large O_DIRECT writes correctly&quot;&quot;<br>
<br>
test_80() { # bug 10718<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D/dev/zero of=3D$DIR/$tfile bs=3D1M coun=
t=3D1 seek=3D1M<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0sync; sleep 1; sync<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local BEFORE=3D`date +%s`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cancel_lru_locks osc<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local AFTER=3D`date +%s`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local DIFF=3D$((AFTER-BEFORE))<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ $DIFF -gt 1 ] ; then<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;elapsed=
 for 1M@1T&quot; $DIFF&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0true<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/$tfile<br>
}<br>
run_test 80 &quot;Page eviction is equally fast at high offsets too &quot;&=
quot;<br>
<br>
test_99a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -z &quot;$(which cvs 2&gt;/dev/null)&quot; ] =
&amp;&amp; skip &quot;could not find cvs&quot; &amp;&amp; \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d99cvsroot<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chown $RUNAS_ID $DIR/d99cvsroot<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local oldPWD=3D$PWD =C2=A0 =C2=A0 =C2=A0 # bug =
13584, use $TMP as working dir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $TMP<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS cvs -d $DIR/d99cvsroot init || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $oldPWD<br>
}<br>
run_test 99a &quot;cvs init&quot;&quot;<br>
<br>
test_99b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -z &quot;$(which cvs 2&gt;/dev/null)&quot; ] =
&amp;&amp; skip &quot;could not find cvs&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ ! -d $DIR/d99cvsroot ] &amp;&amp; test_99a<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd /etc/init.d<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# some versions of cvs import exit(1) when aske=
d to import links or<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# files they can&#39;t read. =C2=A0ignore those=
 files.<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0TOIGNORE=3D$(find . -type l -printf &#39;-I %f\=
n&#39; -o \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0! -perm +4 -printf &#39;-I %f\n&#39;)<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS cvs -d $DIR/d99cvsroot import -m &quot;n=
omesg&quot; $TOIGNORE \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0d99reposname vtag r=
tag<br>
}<br>
run_test 99b &quot;cvs import&quot;&quot;<br>
<br>
test_99c() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -z &quot;$(which cvs 2&gt;/dev/null)&quot; ] =
&amp;&amp; skip &quot;could not find cvs&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ ! -d $DIR/d99cvsroot ] &amp;&amp; test_99b<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d99reposname<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chown $RUNAS_ID $DIR/d99reposname<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS cvs -d $DIR/d99cvsroot co d99reposname<b=
r>
}<br>
run_test 99c &quot;cvs checkout&quot;&quot;<br>
<br>
test_99d() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -z &quot;$(which cvs 2&gt;/dev/null)&quot; ] =
&amp;&amp; skip &quot;could not find cvs&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ ! -d $DIR/d99cvsroot ] &amp;&amp; test_99c<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR/d99reposname<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS touch foo99<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS cvs add -m &#39;addmsg&#39; foo99<br>
}<br>
run_test 99d &quot;cvs add&quot;&quot;<br>
<br>
test_99e() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -z &quot;$(which cvs 2&gt;/dev/null)&quot; ] =
&amp;&amp; skip &quot;could not find cvs&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ ! -d $DIR/d99cvsroot ] &amp;&amp; test_99c<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR/d99reposname<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS cvs update<br>
}<br>
run_test 99e &quot;cvs update&quot;&quot;<br>
<br>
test_99f() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -z &quot;$(which cvs 2&gt;/dev/null)&quot; ] =
&amp;&amp; skip &quot;could not find cvs&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ ! -d $DIR/d99cvsroot ] &amp;&amp; test_99d<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR/d99reposname<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS cvs commit -m &#39;nomsg&#39; foo99<br>
 =C2=A0 =C2=A0rm -fr $DIR/d99cvsroot<br>
}<br>
run_test 99f &quot;cvs commit&quot;&quot;<br>
<br>
function get_named_value()<br>
{<br>
 =C2=A0 =C2=A0local tag<br>
<br>
 =C2=A0 =C2=A0tag=3D$1<br>
 =C2=A0 =C2=A0while read ;do<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0line=3D$REPLY<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0case $line in<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$tag*)<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo $line | sed &quot;s/^$tag//&=
quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0;;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0esac<br>
 =C2=A0 =C2=A0done<br>
}<br>
<br>
export SETUP_TEST102=3Dno<br>
setup_test102() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ &quot;$SETUP_TEST102&quot;&quot; &quot;yes&qu=
ot; ] &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/$tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chown $RUNAS_ID $DIR/$tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0STRIPE_SIZE=3D65536<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0STRIPE_OFFSET=3D1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0STRIPE_COUNT=3D$OSTCOUNT<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $OSTCOUNT -gt 4 ] &amp;&amp; STRIPE_COUNT=3D4=
<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0trap cleanup_test102 EXIT<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$1 $SETSTRIPE $tdir -s $STRIPE_SIZE -i $STRIPE_=
OFFSET -c $STRIPE_COUNT<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR/$tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0for num in 1 2 3 4<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0do<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for count in `seq 1=
 $STRIPE_COUNT`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0do<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0for offset in `seq 0 $[$STRIPE_COUNT - 1]`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0do<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0local stripe_size=3D`expr $STRIPE_SIZ=
E \* $num`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0local file=3Dfile&quot;$num-$offset-$=
count&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$1 $SETSTRIPE $file -s $stripe_size -=
i $offset -c $count<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0done<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0done<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0done<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$1 $TAR cf $TMP/f102.tar $tdir --xattrs<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0SETUP_TEST102=3Dyes<br>
}<br>
<br>
cleanup_test102() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0trap 0<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ &quot;$SETUP_TEST102&quot;&quot; &quot;yes&qu=
ot; ] || return 0<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $TMP/f102.tar<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0SETUP_TEST102=3Dno<br>
}<br>
<br>
test_102a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local testfile=3D$DIR/xattr_testfile<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $testfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $testfile<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ &quot;$UID&quot; !=3D 0 ] &amp;&amp; skip &qu=
ot;must run as root&quot; &amp;&amp; return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -z &quot;`lctl get_param -n mdc.*-mdc-*.conne=
ct_flags | grep xattr`&quot; ] &amp;&amp; skip &quot;must have user_xattr&q=
uot; &amp;&amp; return<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -z &quot;$(which setfattr 2&gt;/dev/null)&quo=
t; ] &amp;&amp; skip &quot;could not find setfattr&quot; &amp;&amp; return<=
br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;set/get xattr...&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0setfattr -n trusted.name1 -v value1 $testfile |=
| error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ &quot;`getfattr -n trusted.name1 $testfile 2&=
gt; /dev/null | \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0grep &quot;trusted.name1&quot;`&quot;&quot; &qu=
ot;trusted.name1=3D\&quot;value1\&quot;&quot; ] || error<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0setfattr -n user.author1 -v author1 $testfile |=
| error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ &quot;`getfattr -n user.author1 $testfile 2&g=
t; /dev/null | \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0grep &quot;user.author1&quot;`&quot;&quot; &quo=
t;user.author1=3D\&quot;author1\&quot;&quot; ] || error<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;listxattr...&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0setfattr -n trusted.name2 -v value2 $testfile |=
| error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0setfattr -n trusted.name3 -v value3 $testfile |=
| error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ `getfattr -d -m &quot;^trusted&quot; $testfil=
e 2&gt; /dev/null | \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0grep &quot;<a href=3D"http://trusted.name" targ=
et=3D"_blank">trusted.name</a>&quot; | wc -l` -eq 3 ] || error<br>
<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0setfattr -n user.author2 -v author2 $testfile |=
| error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0setfattr -n user.author3 -v author3 $testfile |=
| error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ `getfattr -d -m &quot;^user&quot; $testfile 2=
&gt; /dev/null | \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0grep &quot;user&quot; | wc -l` -eq 3 ] || error=
<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;remove xattr...&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0setfattr -x trusted.name1 $testfile || error<br=
>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0getfattr -d -m trusted $testfile 2&gt; /dev/nul=
l | \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0grep &quot;trusted.name1&quot; &amp;&amp; error=
 || true<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0setfattr -x user.author1 $testfile || error<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0getfattr -d -m user $testfile 2&gt; /dev/null |=
 \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0grep &quot;user.author1&quot; &amp;&amp; error =
|| true<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# b10667: setting lustre special xattr be silen=
tly discarded<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;set lustre special xattr ...&quot;<b=
r>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0setfattr -n &quot;trusted.lov&quot; -v &quot;in=
valid value&quot; $testfile || error<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $testfile<br>
}<br>
run_test 102a &quot;user xattr test&quot;&quot;<br>
<br>
test_106() { #bug 10921<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/$tdir<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$DIR/$tdir &amp;&amp; error &quot;exec $DIR/$td=
ir succeeded&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0chmod 777 $DIR/$tdir || error &quot;chmod $DIR/=
$tdir failed&quot;<br>
}<br>
run_test 106 &quot;attempt exec of dir followed by chown of that dir&quot;<=
br>
<br>
test_107() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0CDIR=3D`pwd`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local file=3Dcore<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $file<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local save_pattern=3D$(sysctl -n kernel.core_pa=
ttern)<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local save_uses_pid=3D$(sysctl -n kernel.core_u=
ses_pid)<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0sysctl -w kernel.core_pattern=3D$file<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0sysctl -w kernel.core_uses_pid=3D0<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ulimit -c unlimited<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0sleep 60 &amp;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0SLEEPPID=3D$!<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0sleep 1<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0kill -s 11 $SLEEPPID<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0wait $SLEEPPID<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ -e $file ]; then<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0size=3D`stat -c%s $=
file`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $size -eq 0 ] &am=
p;&amp; error &quot;Fail to create core file $file&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;Fail to=
 create core file $file&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $file<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0sysctl -w kernel.core_pattern=3D$save_pattern<b=
r>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0sysctl -w kernel.core_uses_pid=3D$save_uses_pid=
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $CDIR<br>
}<br>
run_test 107 &quot;Coredump on SIG&quot;<br>
<br>
test_110() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/d110<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d110/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa =
|| error &quot;mkdir with 255 char fail&quot;<br>

 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir $DIR/d110/bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb=
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb=
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb=
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb=
 &amp;&amp; error &quot;mkdir with 256 char should fail, but not&quot;<br>

 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d110/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx =
|| error &quot;create with 255 char fail&quot;<br>

 =C2=A0 =C2=A0 =C2=A0 =C2=A0touch $DIR/d110/yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
 &amp;&amp; error &quot;&quot;create with 256 char should fail, but not<br>

<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0ls -l $DIR/d110<br>
 =C2=A0 =C2=A0rm -fr $DIR/d110<br>
}<br>
run_test 110 &quot;filename length checking&quot;<br>
<br>
test_119a() # bug 11737<br>
{<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0BSIZE=3D$((512 * 1024))<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0directio write $DIR/$tfile 0 1 $BSIZE<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# We ask to read two blocks, which is more than=
 a file size.<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# directio will indicate an error when requeste=
d and actual<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# sizes aren&#39;t equal (a normal situation in=
 this case) and<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# print actual read amount.<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0NOB=3D`directio read $DIR/$tfile 0 2 $BSIZE | a=
wk &#39;/error/ {print $6}&#39;`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ &quot;$NOB&quot; !=3D &quot;$BSIZE&quot; ]=
; then<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;read $N=
OB bytes instead of $BSIZE&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/$tfile<br>
}<br>
run_test 119a &quot;Short directIO read must return actual read amount&quot=
;<br>
<br>
test_119b() # bug 11737<br>
{<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D/dev/zero of=3D$DIR/$tfile bs=3D1M coun=
t=3D1 seek=3D1 || error &quot;dd failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0sync<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0multiop $DIR/$tfile oO_RDONLY:O_DIRECT:r$((2048=
 * 1024)) || \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;direct =
read failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/$tfile<br>
}<br>
run_test 119b &quot;Sparse directIO read must return actual read amount&quo=
t;<br>
<br>
test_119c() # bug 13099<br>
{<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0BSIZE=3D1048576<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0directio write $DIR/$tfile 3 1 $BSIZE || error =
&quot;direct write failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0directio readhole $DIR/$tfile 0 2 $BSIZE || err=
or &quot;reading hole failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/$tfile<br>
}<br>
run_test 119c &quot;Testing for direct read hitting hole&quot;<br>
<br>
test_126() { # bug 12829/13455<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ &quot;$UID&quot; !=3D 0 ] &amp;&amp; echo &qu=
ot;skipping $TESTNAME (must run as root)&quot; &amp;&amp; return<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0$RUNAS -u 0 -g 1 touch $DIR/$tfile || error &qu=
ot;touch failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0gid=3D`ls -n $DIR/$tfile | awk &#39;{print $4}&=
#39;`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $gid -eq &quot;1&quot; ] || error &quot;gid i=
s set to&quot; $gid &quot;instead of 1&quot;<br>
}<br>
run_test 126 &quot;check that the fsgid provided by the client is taken int=
o account&quot;<br>
<br>
OLDIFS=3D&quot;$IFS&quot;<br>
cleanup_130() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0trap 0<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0IFS=3D&quot;$OLDIFS&quot;<br>
}<br>
<br>
test_130a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0filefrag_op=3D$(filefrag -e 2&gt;&amp;1 | grep =
&quot;invalid option&quot;)<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -n &quot;$filefrag_op&quot; ] &amp;&amp; skip=
 &quot;filefrag does not support FIEMAP&quot; &amp;&amp; return<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0trap cleanup_130 EXIT RETURN<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local fm_file=3D$DIR/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D/dev/zero of=3D$fm_file bs=3D65536 coun=
t=3D1 || error &quot;dd failed for $fm_file&quot;<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0filefrag -ves $fm_file || error &quot;filefrag =
$fm_file failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0filefrag_op=3D`filefrag -ve $fm_file | grep -A =
100 &quot;ext:&quot; | grep -v &quot;ext:&quot; | grep -v &quot;found&quot;=
`<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0start_blk=3D`echo $filefrag_op | cut -d: -f2 | =
cut -d. -f1`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0IFS=3D$&#39;\n&#39;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0tot_len=3D0<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0for line in $filefrag_op; do<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext_len=3D`echo $li=
ne | cut -d: -f4`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(( tot_len +=3D ext=
_len ))<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0done<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (( start_blk !=3D 0 || tot_len !=3D 64 )); t=
hen<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cleanup_130<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;FIEMAP =
on 1-stripe file($fm_file) failed;&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cleanup_130<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;FIEMAP on single striped file succee=
ded&quot;<br>
}<br>
run_test 130a &quot;FIEMAP (1-stripe file)&quot;<br>
<br>
test_130e() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0skip &quot;this test needs cleanup for non-lust=
re&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0filefrag_op=3D$(filefrag -e 2&gt;&amp;1 | grep =
&quot;invalid option&quot;)<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ -n &quot;$filefrag_op&quot; ] &amp;&amp; skip=
 &quot;filefrag does not support FIEMAP&quot; &amp;&amp; return<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0trap cleanup_130 EXIT RETURN<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local fm_file=3D$DIR/$tfile<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0NUM_BLKS=3D512<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0EXPECTED_LEN=3D$(( (NUM_BLKS / 2) * 4 ))<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0for ((i&quot; 0; i &lt; $NUM_BLKS; i++))<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0do<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D/dev/zero o=
f=3D$fm_file count=3D1 bs=3D4096 seek=3D$((2*$i)) conv=3Dnotrunc &gt; /dev/=
null 2&gt;&amp;1<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0done<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0filefrag -ves $fm_file || error &quot;filefrag =
$fm_file failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0filefrag_op=3D`filefrag -ve $fm_file | grep -A =
750 &quot;ext:&quot; | grep -v &quot;ext:&quot; | grep -v &quot;found&quot;=
`<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0IFS=3D$&#39;\n&#39;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0tot_len=3D0<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0for line in $filefrag_op; do<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ext_len=3D`echo $li=
ne | cut -d: -f4`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(( tot_len +=3D ext=
_len ))<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0done<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (( tot_len !=3D $EXPECTED_LEN )); then<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cleanup_130<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;FIEMAP =
on $fm_file failed; len $tot_len !=3D $EXPECTED_LEN&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cleanup_130<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;FIEMAP with continuation calls succe=
eded&quot;<br>
}<br>
run_test 130e &quot;FIEMAP (test continuation FIEMAP calls)&quot;<br>
<br>
# Test for writev/readv<br>
test_131a() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rwv -f $DIR/$tfile -w -n 3 524288 1048576 15728=
64 || \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;writev test failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rwv -f $DIR/$tfile -r -v -n 2 1572864 1048576 |=
| \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;readv failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/$tfile<br>
}<br>
run_test 131a &quot;test iov&#39;s crossing stripe boundary for writev/read=
v&quot;<br>
<br>
test_131b() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rwv -f $DIR/$tfile -w -a -n 3 524288 1048576 15=
72864 || \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;append writev test failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rwv -f $DIR/$tfile -w -a -n 2 1572864 1048576 |=
| \<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;append writev test failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/$tfile<br>
}<br>
run_test 131b &quot;test append writev&quot;<br>
<br>
test_131c() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rwv -f $DIR/$tfile -w -d -n 1 1048576 || return=
 0<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;NOT PASS&quot;<br>
}<br>
run_test 131c &quot;test read/write on file w/o objects&quot;<br>
<br>
test_131d() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rwv -f $DIR/$tfile -w -n 1 1572864<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0NOB=3D`rwv -f $DIR/$tfile -r -n 3 524288 524288=
 1048576 | awk &#39;/error/ {print $6}&#39;`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0if [ &quot;$NOB&quot; !=3D 1572864 ]; then<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;Short r=
ead filed: read $NOB bytes instead of 1572864&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fi<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/$tfile<br>
}<br>
run_test 131d &quot;test short read&quot;<br>
<br>
test_131e() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rwv -f $DIR/$tfile -w -s 1048576 -n 1 1048576<b=
r>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rwv -f $DIR/$tfile -r -z -s 0 -n 1 524288 || \<=
br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;read hitting hole failed&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -f $DIR/$tfile<br>
}<br>
run_test 131e &quot;test read hitting hole&quot;<br>
<br>
test_140() { #bug-17379<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $DIR/$tdir || error &quot;Creating dir=
 $DIR/$tdir&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $DIR/$tdir || error &quot;Changing to $DIR/$=
tdir&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0cp /usr/bin/stat . || error &quot;Copying stat =
to $DIR/$tdir&quot;<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# VFS limits max symlink depth to 8<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0local i=3D0<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0while i=3D`expr $i + 1`; do<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $i || erro=
r &quot;Creating dir $i&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cd $i || error &quo=
t;Changing to $i&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ln -s ../stat stat =
|| error &quot;Creating stat symlink&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0# Read the symlink =
until ELOOP present,<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0# not LBUGing the s=
ystem is considered success,<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0# we didn&#39;t ove=
rrun the stack.<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$OPENFILE -f O_RDON=
LY stat &gt;/dev/null 2&gt;&amp;1; ret=3D$?<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $ret -ne 0 ] &amp=
;&amp; {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if [ $ret -eq 40 ]; then<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break =C2=A0# -ELOOP<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0else<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error &quot;Open stat symlink&quot;<b=
r>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0fi<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0done<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0i=3D`expr $i - 1`<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;The symlink depth&quot; $i&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ $i -eq 8 ] || error &quot;Invalid symlink dep=
th&quot;<br>
}<br>
run_test 140 &quot;Check reasonable stack depth (shouldn&#39;t LBUG)&quot;&=
quot;<br>
<br>
test_154() {<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0# do directio so as not to populate the page ca=
che<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0log &quot;creating a 10 Mb file&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0multiop $DIR/$tfile oO_CREAT:O_DIRECT:O_RDWR:w$=
((10*1048576))c || error &quot;multiop failed while creating a file&quot;<b=
r>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0log &quot;starting reads&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0dd if=3D$DIR/$tfile of=3D/dev/null bs=3D4096 &a=
mp;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0log &quot;truncating the file&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0multiop $DIR/$tfile oO_TRUNC:c || error &quot;m=
ultiop failed while truncating the file&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0log &quot;killing dd&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0kill %+ || true # reads might have finished<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;wait until dd is finished&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0wait<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0log &quot;removing the temporary file&quot;<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0rm -rf $DIR/$tfile || error &quot;tmp file remo=
val failed&quot;<br>
}<br>
run_test 154 &quot;parallel read and truncate should not deadlock&quot;&quo=
t;<br>
<br>
echo &quot;$0: completed&quot;<br>
<font color=3D"#888888"><br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe linux-ext4&q=
uot; in<br>
the body of a message to <a href=3D"mailto:majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org">major=
domo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org</a><br>
More majordomo info at =C2=A0<a href=3D"http://vger.kernel.org/majordomo-in=
fo.html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><b=
r>
</font></blockquote></div><br><br clear=3D"all"><br>-- <br>Regards &amp; Th=
anks--<br>Subrata<br>

--00163646c228cdfa43046a925441--


--===============3634720694974603220==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Register Now for Creativity and Technology (CaT), June 3rd, NYC. CaT
is a gathering of tech-side developers & brand creativity professionals. Meet
the minds behind Google Creative Lab, Visual Complexity, Processing, & 
iPhoneDevCamp asthey present alongside digital heavyweights like Barbarian
Group, R/GA, & Big Spaceship. http://www.creativitycat.com 
--===============3634720694974603220==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ltp-list mailing list
Ltp-list-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/ltp-list

--===============3634720694974603220==--
