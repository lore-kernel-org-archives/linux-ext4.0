From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 21/25] tests: test e2fsck recovery of corrupt descriptor
 blocks
Date: Tue, 9 Sep 2014 18:15:29 -0700
Message-ID: <20140910011529.GG10351@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231355.25904.14661.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27612 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaIJBPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2014 21:15:35 -0400
Content-Disposition: inline
In-Reply-To: <20140908231355.25904.14661.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:13:55PM -0700, Darrick J. Wong wrote:
> Test e2fsck' ability to deal with (a) corrupt descriptor block
> checksum; (b) obviously bad journal block tid; and (c) corrupt journal
> blocks.  These should exercise the journal recovery infinite loop
> bugfix earlier in this patchset.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/j_corrupt_descr_csum/expect      |   18 +++++++++++
>  tests/j_corrupt_descr_csum/image.gz    |  Bin
>  tests/j_corrupt_descr_csum/name        |    1 +
>  tests/j_corrupt_descr_csum/script      |   51 ++++++++++++++++++++++++++++++++
>  tests/j_corrupt_descr_tid/expect       |   17 +++++++++++
>  tests/j_corrupt_descr_tid/image.gz     |  Bin
>  tests/j_corrupt_descr_tid/name         |    1 +
>  tests/j_corrupt_descr_tid/script       |   51 ++++++++++++++++++++++++++++++++
>  tests/j_corrupt_journal_block/expect   |   19 ++++++++++++

NAK, this file is incorrect.  As noted in a previous email, the revoke block
should itself be revoked (and the replay restarted) if we encounter corrupt
blocks.

Silly /me didn't consider that revoke records aren't intended to unilaterally
kill journal blocks; they only make sense if there's a subsequent transaction
also writing the block.

--D

>  tests/j_corrupt_journal_block/image.gz |  Bin
>  tests/j_corrupt_journal_block/name     |    1 +
>  tests/j_corrupt_journal_block/script   |   51 ++++++++++++++++++++++++++++++++
>  12 files changed, 210 insertions(+)
>  create mode 100644 tests/j_corrupt_descr_csum/expect
>  create mode 100644 tests/j_corrupt_descr_csum/image.gz
>  create mode 100644 tests/j_corrupt_descr_csum/name
>  create mode 100644 tests/j_corrupt_descr_csum/script
>  create mode 100644 tests/j_corrupt_descr_tid/expect
>  create mode 100644 tests/j_corrupt_descr_tid/image.gz
>  create mode 100644 tests/j_corrupt_descr_tid/name
>  create mode 100644 tests/j_corrupt_descr_tid/script
>  create mode 100644 tests/j_corrupt_journal_block/expect
>  create mode 100644 tests/j_corrupt_journal_block/image.gz
>  create mode 100644 tests/j_corrupt_journal_block/name
>  create mode 100644 tests/j_corrupt_journal_block/script
> 
> 
> diff --git a/tests/j_corrupt_descr_csum/expect b/tests/j_corrupt_descr_csum/expect
> new file mode 100644
> index 0000000..419e775
> --- /dev/null
> +++ b/tests/j_corrupt_descr_csum/expect
> @@ -0,0 +1,18 @@
> +test_filesys: recovering journal
> +../e2fsck/e2fsck: Input/output error while recovering ext3 journal of test_filesys
> +
> +test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
> +
> +test_filesys: ********** WARNING: Filesystem still has errors **********
> +
> +Exit status is 12
> +test_filesys: recovering journal
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +test_filesys: 12/128 files (8.3% non-contiguous), 1093/2048 blocks
> +Exit status is 0
> +debugfs: cat /a
> +aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
>  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
>  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
>  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
>  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
> \ No newline at end of file
> diff --git a/tests/j_corrupt_descr_csum/image.gz b/tests/j_corrupt_descr_csum/image.gz
> new file mode 100644
> index 0000000000000000000000000000000000000000..2a81e5daeb13fcec40d8fa9ef95151427a35b584
> GIT binary patch
> literal 2989
> zcmeIz{WIGK90%~AZF)0h>dI+O^eVOMRO%2mCN1k(kuutNzHG8aiAYOP59jORX~~qf
> zPSS`*v#nb591mqkHuKO<mLQ6GTxcjMsfR4`^!;x8vHk?-^V{b>_xa)dy3gGQ`TbGY
> z$Pq=DvB~-z?gru-0`|_Mn^TF_v5)XB=Bq*(2|FR5d@zVN{rt|z(X6DlB1Q`jQ$eHA
> z8LUN|i=DSs)<-m}v+EZbs;{5n3j@%DKTO7rT%FE`yNHKHzCIY+@4m$?t4*n-3{rYL
> zRIZWqu>X2wZ5(p-_ZF#*FEFjENA!hE2a|$F*cG0!*_nI~rbAG$`U=WbO2Ji!J2nU!
> zQNY&C>67TfcX6l!M~;}#og>@C4jmJw$m?GB2X14B8d+r@p2Jp}nHIT;v-GR6j=?>^
> zTYBmCab2-_&*(Ps!A`+MD8_kkG^Z7DwzUQ=m$9}o=DAE<0y}^eM*UMmt=g_XZ3s*Z
> zx^@|E*ASt8)|Bnztr}i#12UpEs$W99+p!Y7C_h}N$^01M(>X;}BRo@wEf2xot2}6M
> z2kI}<7GS;24xdm`q_z)2!(VKqN^Jw4G&a7q^P%v%+|J)gx)Bfky?MHLvD3o2qWmWb
> z={UaKjRk1yWNW3&ObyUmCC4^*Yy;7fp|H)(2EN?r(lBIQDiGknd_DX%)*dp_n7;rn
> zfF@hWdr+PpjwgVGoHxIX?j+3HrajS~$3({-OXV0ZSbDinZ*ryms>H+z?R~!=QDoyw
> z%oTvEtmu6uTPRhhIaU3_N3Xk~eFTEUBu?I?ajmSE@P*$kZ#c~AO0J&pheTc2y5Q~r
> z-4=~_MJAUS20h>sPa4hr7T9zOn+Evja;Z%y6Y@-NKC%ZxhOnut$!hDBbY}_#$Rh(S
> zCPXS>QI2rIrnsy$#*orJu&6~k&H0DL8YCu#?sXtiVpLH6Xin)|3qlhcijK$4q%}w}
> zriF;Fw7|lYN%lDO&H87C%PDIXArY<rjTSL7v6QGj*8l=|1M+`-JiS5way~J#Hgn_Q
> z&%mtE$Cf0}AeNFPftVTupJU=KjzLfaY*E+quMi#AyEXx&ufNSy&MN!qOk6F9Wbnml
> z=2l)SXPm9QKy@xUU9ZD7LGd<rbb3Us(=6!7OJyq!<H8cG-hUQEc`Pf7@!nvw%Qyq8
> zJ0l8moC8@aNzjsj=c*ivev=eDT+<d*;TMqzTd5@Kg}qUdUB&A3<bW7bQ70kSm=aa>
> zMwChz3KB=wwAkmMw369zU99U9bb?6WDOUll-gkQV&ta9&q1#^Yr2!2_<SH$x>7TZc
> zXUyA+JnjzdQcLg(prv0EuAseldwZG-hJlVCVpxq?0-eI0Kf%WnIAdc~Oy<3IbyjxN
> zL~(uZ(%n;JrOlqTgZ4n+Kw$p~Jf7FWV0nEv5AFF_`!DH1q62~bCGcy&?#Ysla&s8W
> G9`-Nik0OEq
> 
> literal 0
> HcmV?d00001
> 
> diff --git a/tests/j_corrupt_descr_csum/name b/tests/j_corrupt_descr_csum/name
> new file mode 100644
> index 0000000..e15ccfb
> --- /dev/null
> +++ b/tests/j_corrupt_descr_csum/name
> @@ -0,0 +1 @@
> +corrupt descr csum (csum v3)
> diff --git a/tests/j_corrupt_descr_csum/script b/tests/j_corrupt_descr_csum/script
> new file mode 100644
> index 0000000..102feba
> --- /dev/null
> +++ b/tests/j_corrupt_descr_csum/script
> @@ -0,0 +1,51 @@
> +if test -x $DEBUGFS_EXE; then
> +
> +IMAGE=$test_dir/image.gz
> +FSCK_OPT=-fy
> +OUT=$test_name.log
> +if [ -f $test_dir/expect.gz ]; then
> +	EXP=$test_name.tmp
> +	gunzip < $test_dir/expect.gz > $EXP1
> +else
> +	EXP=$test_dir/expect
> +fi
> +
> +cp /dev/null $OUT
> +
> +gzip -d < $IMAGE > $TMPFILE
> +
> +$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT.new
> +sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
> +rm -f $OUT.new
> +
> +$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT.new
> +sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
> +rm -f $OUT.new
> +
> +echo "cat /a" > $TMPFILE.cmd
> +$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
> +rm -f $TMPFILE.cmd
> +
> +rm -f $TMPFILE
> +
> +cmp -s $OUT $EXP
> +status=$?
> +
> +if [ "$status" = 0 ] ; then
> +	echo "$test_name: $test_description: ok"
> +	touch $test_name.ok
> +else
> +	echo "$test_name: $test_description: failed"
> +	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
> +	rm -f $test_name.tmp
> +fi
> +
> +unset IMAGE FSCK_OPT OUT EXP
> +
> +else #if test -x $DEBUGFS_EXE; then
> +	echo "$test_name: $test_description: skipped"
> +fi
> diff --git a/tests/j_corrupt_descr_tid/expect b/tests/j_corrupt_descr_tid/expect
> new file mode 100644
> index 0000000..0444203
> --- /dev/null
> +++ b/tests/j_corrupt_descr_tid/expect
> @@ -0,0 +1,17 @@
> +test_filesys: recovering journal
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +test_filesys: 12/128 files (8.3% non-contiguous), 1093/2048 blocks
> +Exit status is 0
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +test_filesys: 12/128 files (8.3% non-contiguous), 1093/2048 blocks
> +Exit status is 0
> +debugfs: cat /a
> +aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
>  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
>  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
>  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
>  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
> \ No newline at end of file
> diff --git a/tests/j_corrupt_descr_tid/image.gz b/tests/j_corrupt_descr_tid/image.gz
> new file mode 100644
> index 0000000000000000000000000000000000000000..3ad88f9d15549c24758ae53015a08b62f938f5f8
> GIT binary patch
> literal 2999
> zcmeIw|1;Zn90%}dw7R;Loo_88Y`3Xv6<1ptN~l)q)S|TYU0ROBx6oy%FKP6&i!p6?
> zH;sx>U2!3%i3k;up<zb|O3ark3*yU3NMy*D&wIBY+dsj1{r3Ff^~3Y=dLc@V!s3k9
> zLl40>-eFVCZ=8T_B6(3~YIW4U2mUr&7mE&~?ETG7pZdheB+|?)L|Etl(zn>*T6|-l
> z@m3wn?!uD{H-{e$;YJtV6dGO*a*bwQYQFSB_-A(^tE;VrzAe5<AAiMFX@6;J@jSO7
> zM~aZDjjQ<BqdwO@t*1&%HPZQ1)PtJyqOZjxWo_;_%wBGKazuIgimkXo)%3V|y+uMH
> zMr;Us?_|`N_mq^GRz>G7uho(sgPgeevO!z|Cbj}XaXa&G5uj0KrCVL*m`W`7&Rs0@
> z!~Rfpa>lDuHdKXZVLEbX$|R>pT>4V*Gj|HZ@*d+~I<k-J!QE=F%(dwP4NlD-QUS9&
> zy6n92maqdudZ!&_;UsSsyjW?C%OE&<Qe{C>l%?OZI|k3gYo~1UzMEqk8o)l7d4by&
> zn#D#fm|%VG*XGS|sLXL&rFND>4Po#+1ypgz$jxc=T>^mw<`>}FF^=ikr!7ozqM0S9
> zd=Ral_&(t+J86&7R4GHhYFAPG#E#O{y(adO!R0|<b-b&~7b?^lEu!s#!Jf%q6dwq#
> zL_7fnIwQ+isG73UJ-W-5*ksm1?wL_B$3uCCaCAHCZK+pn$@;_bCiRzE|3HahG4m;i
> z=&*E6R19l&(_OYRhbwvP)83pRZ~klRRC+-~Co64lYSn6v_l0$_6a{;pk^CM6wo1th
> z<JrzrXfl3<A1lAoD``7|)f_oo^3N_VaAQROTdOqR)A?lhtlUPo*&3h)YYg57u5#`|
> zn;tCToqfYUmjR{q^N#oFK~fCnkNnpoad#k-Ww~@q4$1EKR9px3@vsHLq-1CLIuP*n
> z70##5RA?vxOn_*d1Y}3MziS|>aDBIaibeLh9n=75FVlKr`mwX<HVybygZTdnmPP8N
> zb-p@_H%EGVS0#niqrv(?nRzy*X(@ETL4XQQQ7;l^hEfOkrDN@_s#2ge_2`AZv8v9=
> zjY(Dm>I)_*YRAe`)_2yz6WXD;Wa)V5bO?XKF5stdhG-VT*Q8Vlv<%8K?@i1!lz^;L
> zP>FfE+cya26o}?JL2cK&V5gvZvR_zQIkBe2jXS|ArTLYo!0Km0bOQdgXqUdaHYpqi
> z77BN8t`e&jOZ?S1MwT0atgns)oPI8`N<k)uMFJDSj7SZ3uh?Df|5@WQh%FL_fZCF!
> z?BT6MT71;Ex)FkI%-9LC`CYAXY2Aj@k)|Jf;YWecHBL)f8{mA!9ha@zIw;hcNvUZp
> zXX6}7^I&|`XG-W%*uzdi{6|{{@j&1}VE+jeB(B3@uw%VQ`~BDLpwWTAz7`--1qKMw
> Kr~n4Dhy4e5RXFwl
> 
> literal 0
> HcmV?d00001
> 
> diff --git a/tests/j_corrupt_descr_tid/name b/tests/j_corrupt_descr_tid/name
> new file mode 100644
> index 0000000..2325d6d
> --- /dev/null
> +++ b/tests/j_corrupt_descr_tid/name
> @@ -0,0 +1 @@
> +corrupt descr tid (csum v3)
> diff --git a/tests/j_corrupt_descr_tid/script b/tests/j_corrupt_descr_tid/script
> new file mode 100644
> index 0000000..102feba
> --- /dev/null
> +++ b/tests/j_corrupt_descr_tid/script
> @@ -0,0 +1,51 @@
> +if test -x $DEBUGFS_EXE; then
> +
> +IMAGE=$test_dir/image.gz
> +FSCK_OPT=-fy
> +OUT=$test_name.log
> +if [ -f $test_dir/expect.gz ]; then
> +	EXP=$test_name.tmp
> +	gunzip < $test_dir/expect.gz > $EXP1
> +else
> +	EXP=$test_dir/expect
> +fi
> +
> +cp /dev/null $OUT
> +
> +gzip -d < $IMAGE > $TMPFILE
> +
> +$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT.new
> +sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
> +rm -f $OUT.new
> +
> +$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT.new
> +sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
> +rm -f $OUT.new
> +
> +echo "cat /a" > $TMPFILE.cmd
> +$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
> +rm -f $TMPFILE.cmd
> +
> +rm -f $TMPFILE
> +
> +cmp -s $OUT $EXP
> +status=$?
> +
> +if [ "$status" = 0 ] ; then
> +	echo "$test_name: $test_description: ok"
> +	touch $test_name.ok
> +else
> +	echo "$test_name: $test_description: failed"
> +	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
> +	rm -f $test_name.tmp
> +fi
> +
> +unset IMAGE FSCK_OPT OUT EXP
> +
> +else #if test -x $DEBUGFS_EXE; then
> +	echo "$test_name: $test_description: skipped"
> +fi
> diff --git a/tests/j_corrupt_journal_block/expect b/tests/j_corrupt_journal_block/expect
> new file mode 100644
> index 0000000..50d0b78
> --- /dev/null
> +++ b/tests/j_corrupt_journal_block/expect
> @@ -0,0 +1,19 @@
> +test_filesys: recovering journal
> +JBD2: Invalid checksum recovering block 1090 in log
> +../e2fsck/e2fsck: Input/output error while recovering ext3 journal of test_filesys
> +
> +test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
> +
> +test_filesys: ********** WARNING: Filesystem still has errors **********
> +
> +Exit status is 12
> +test_filesys: recovering journal
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +test_filesys: 12/128 files (8.3% non-contiguous), 1093/2048 blocks
> +Exit status is 0
> +debugfs: cat /a
> +aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!
>  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
 bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
>  bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb!
>  bbbbbbbbbbddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
 ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd!
>  dddddddddddddddddddddddddddddddddddddddddddddd
> \ No newline at end of file
> diff --git a/tests/j_corrupt_journal_block/image.gz b/tests/j_corrupt_journal_block/image.gz
> new file mode 100644
> index 0000000000000000000000000000000000000000..f60439f02ea11289639dc2c3e5108bf5b3a662bb
> GIT binary patch
> literal 2998
> zcmeH{`#0Nn9L9rfY+4+;QXJ8)&h)G}+k!eQ>1>_4giaLA7>#RO>N2;ueW^>kso1n`
> zO;J5_=`;xHn$l$@npC2RTd<}|o6vm|;>Zp8tiQH@LXY=v&kye(p4ao72U(_v@YH#Y
> z)7F9i#l~8mw?u3>4^wV-_N@gO8KZ(7no-nmrhmIkn{hX^LS449pf(c{+px{I33pyJ
> zXW_2t8kU3<TbFp{*p6j)1+=@{)Xd(QBTNM>6zP7+VLx$4JDFci!@g4JCq-vQXT*T(
> zDlWZFP;aVzE})3UH)9m`W_DOIPA~Yi_)S$+oeIq%(VeT0`}oRzkK_1>XB&e)r;c>k
> zK(ez7!@-{{H+$*%Io3bOSM8cWWUJh5*4*RGniz;o?X<KC&PBD04iIn2m0LM}mS97C
> zy*{QBKC-kE$gS|?nc%$z17;pu)YLW~%E*l?VJsmj0zdm_)Ui<C2aY14)5?Vyb<K3`
> zUzG-K{xr#tVG1Z$R&$>SMtTz(S)ed2lpFXYFG8qsGcu4+r1xDF4MT|^Ya`yehfstJ
> zBBbXrkhhAp%M^XYgPwO?BNc<hgU$Y#nHh$S+f9RMZ9x3+mChd1Kw7clJ`mtriKbwK
> zdAtzKT4yN@Yu6(KKe(`=aFPh};I^7<Zo=I!wa&1CX$Af1QShxsM~3_z6zuA*VyuCd
> z%5VZYt<mvz01j@uQ^{&nQu&a7o*9K|f29sv*jZL@4rg&=Uu2(fjNcP$mMa|#kFmEf
> zTm`FReM4$5Pv_JRb-ThSE@osTE`d@&q7UZ1928*ain3T+vPi3d@wftbt5hS&>YdWn
> zM)HwtCL5*+l^NiK$GNVP9N@UxDv@%yTX1(|IBAgwp1$VG0j@@pkxPo+V#q;IL(c~n
> z1tB1QLa|exqTHC85AwD<JO{#;(RE^US5&oW0i!k$REQ9aUpo?|4s9C1AzSp_?n+n(
> zU+~mmWkwAN#YL_&;G)W0b<$-JX?u^j4L(hwBy%UkI{NLPF%am!$)Lc7@EwWXkC#ll
> zIb)|Wk}#w`PMAwh=@;2p;0y$lh32jHWGA6l^wOfO!B743N=UEiYfF62njmJD>A#0L
> z6ji^N(Khdr38&Ilz;gwGIVvhsL#2N=)n2V)Ey0lS&|%dxKfqQNL66|D)L-QJVlorC
> z;7(QcBr$x_c`!s8mt!OrL$Z8&31__bo+tZzm*SF-l3QHH!D9UOwb6zS2>0J^*!HD8
> z%s(Z;KoHoj31UG9@Sz}P7Q*wp^Z(dFkGggM=CgK@8uQhS5Bca;O--cfBhg(jhGa|e
> z&nN9W6X5}Td=`Jq3`{P^?KxDR0&$^6Z*}k;(Kb3?O-x|*9<`%Q@`v4L*W+>cn|z*e
> zxBTazmZ<X+3$B;+FXS-a`P!HJ1ojEMhXl4~->l`K($B2lLvQ<*_6fYt1SG|yTAt-}
> J0s>);_#dgmGFbos
> 
> literal 0
> HcmV?d00001
> 
> diff --git a/tests/j_corrupt_journal_block/name b/tests/j_corrupt_journal_block/name
> new file mode 100644
> index 0000000..5d862cd
> --- /dev/null
> +++ b/tests/j_corrupt_journal_block/name
> @@ -0,0 +1 @@
> +corrupt journal block (csum v3)
> diff --git a/tests/j_corrupt_journal_block/script b/tests/j_corrupt_journal_block/script
> new file mode 100644
> index 0000000..102feba
> --- /dev/null
> +++ b/tests/j_corrupt_journal_block/script
> @@ -0,0 +1,51 @@
> +if test -x $DEBUGFS_EXE; then
> +
> +IMAGE=$test_dir/image.gz
> +FSCK_OPT=-fy
> +OUT=$test_name.log
> +if [ -f $test_dir/expect.gz ]; then
> +	EXP=$test_name.tmp
> +	gunzip < $test_dir/expect.gz > $EXP1
> +else
> +	EXP=$test_dir/expect
> +fi
> +
> +cp /dev/null $OUT
> +
> +gzip -d < $IMAGE > $TMPFILE
> +
> +$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT.new
> +sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
> +rm -f $OUT.new
> +
> +$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
> +status=$?
> +echo Exit status is $status >> $OUT.new
> +sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
> +rm -f $OUT.new
> +
> +echo "cat /a" > $TMPFILE.cmd
> +$DEBUGFS_EXE -f $TMPFILE.cmd $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed >> $OUT
> +rm -f $TMPFILE.cmd
> +
> +rm -f $TMPFILE
> +
> +cmp -s $OUT $EXP
> +status=$?
> +
> +if [ "$status" = 0 ] ; then
> +	echo "$test_name: $test_description: ok"
> +	touch $test_name.ok
> +else
> +	echo "$test_name: $test_description: failed"
> +	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
> +	rm -f $test_name.tmp
> +fi
> +
> +unset IMAGE FSCK_OPT OUT EXP
> +
> +else #if test -x $DEBUGFS_EXE; then
> +	echo "$test_name: $test_description: skipped"
> +fi
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
