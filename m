From: Jim Meyering <jim@meyering.net>
Subject: Re: bug#6131: [PATCH]: fiemap support for efficient sparse file copy
Date: Fri, 11 Jun 2010 14:38:08 +0200
Message-ID: <87typ9iw27.fsf@meyering.net>
References: <4BE41FFF.4020809@oracle.com> <871vdho68j.fsf@meyering.net>
	<4BEC0BCC.3080906@oracle.com> <87k4qyl6lw.fsf@meyering.net>
	<4BF683CC.3060407@oracle.com> <4BF6ABE7.3020600@oracle.com>
	<877hmpeivx.fsf@meyering.net> <4BFF763A.9010205@oracle.com>
	<8763286kni.fsf@meyering.net> <4C0275FA.1030901@oracle.com>
	<874ohpywri.fsf@meyering.net> <87y6exuc5i.fsf@meyering.net>
	<874ohdu5b8.fsf@meyering.net> <87eighs1t9.fsf@meyering.net>
	<4C0FA93C.6020205@oracle.com> <87iq5sp7eg.fsf@meyering.net>
	<4C108CB9.8010805@oracle.com> <4C11798B.6090500@cs.ucla.edu>
	<4C1183FD.9010502@oracle.com> <4C11F451.8040304@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Paul Eggert <eggert@CS.UCLA.EDU>, bug-coreutils@gnu.org,
	Joel Becker <Joel.Becker@oracle.com>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Tao Ma <tao.ma@oracle.com>
To: "jeff.liu" <jeff.liu@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:48682 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab0FKMiS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jun 2010 08:38:18 -0400
In-Reply-To: <4C11F451.8040304@oracle.com> (jeff liu's message of "Fri, 11 Jun
	2010 16:31:13 +0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jeff.liu wrote:
> Sunil Mushran wrote:
...
>> I guess we'll have to use FIEMAP_FLAG_SYNC.
> Hi Sunil,
>
> Thanks for the comments.
> So we can ensure the source file synced before mapping in this way.
>
> Hi Jim and Paul,
>
> How about the tiny patch below?
...
> Subject: [PATCH 1/1] copy.c: add FIEMAP_FLAG_SYNC to fiemap ioctl
>
> * src/copy.c (fiemap_copy): Force kernel to sync the source
> file before mapping.
>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  src/copy.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/src/copy.c b/src/copy.c
> index f149be4..f48c74d 100644
> --- a/src/copy.c
> +++ b/src/copy.c
> @@ -191,6 +191,7 @@ fiemap_copy (int src_fd, int dest_fd, size_t buf_size,
>    do
>      {
>        fiemap->fm_length = FIEMAP_MAX_OFFSET;
> +      fiemap->fm_flags = FIEMAP_FLAG_SYNC;
>        fiemap->fm_extent_count = count;

Thanks to both of you.
That patch looks fine, Jeff.
However, at least with ext4 and fedora 13, I require
this change to pass "make check".  Note the new entry
in the "flags" column:

    ==> ff2 <==
    Filesystem type is: ef53
    File size of j2 is 2048 (1 block, blocksize 4096)
     ext logical physical expected length flags
       0       0        0               1 unknown,delalloc,eof
    j2: 1 extent found

So I will apply the test-fixing patch first, then your change,
Jeff, and then rebase to the latest on master.

>From 484903dc41246cb3c774f178f695725561b105a0 Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Fri, 11 Jun 2010 14:34:03 +0200
Subject: [PATCH 1/2] tests: accommodate varying filefrag -v "flags" output

* tests/cp/sparse-fiemap: Accommodate values other than "eof"
in the "flags" column of filefrag -v output
---
 tests/cp/sparse-fiemap |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tests/cp/sparse-fiemap b/tests/cp/sparse-fiemap
index dc0cf60..b6b1103 100755
--- a/tests/cp/sparse-fiemap
+++ b/tests/cp/sparse-fiemap
@@ -68,10 +68,11 @@ $PERL -e 1 || skip_test_ 'skipping part of this test; you lack perl'

 # Extract logical block number and length pairs from filefrag -v output.
 # The initial sed is to remove the "eof" from the normally-empty "flags" field.
+# Similarly, remove flags values like "unknown,delalloc,eof".
 # That is required when that final extent has no number in the "expected" field.
 f()
 {
-  sed 's/ eof$//' $@ \
+  sed 's/ [a-z,][a-z,]*$//' $@ \
     | awk '/^ *[0-9]/ {printf "%d %d ", $2 ,NF < 5 ? $NF : $5 } END {print ""}'
 }

--
1.7.1.501.g23b46
