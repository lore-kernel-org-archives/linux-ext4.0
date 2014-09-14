From: TR Reardon <thomas_reardon@hotmail.com>
Subject: RE: [PATCH 19/34] resize2fs: convert fs to and from 64bit mode
Date: Sun, 14 Sep 2014 13:34:14 -0400
Message-ID: <BAY179-W70F5EE403F82604CE977F9FDCB0@phx.gbl>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>,<20140913221318.13646.90438.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"tytso@mit.edu" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bay004-omc4s11.hotmail.com ([65.54.190.213]:53013 "EHLO
	BAY004-OMC4S11.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851AbaINReO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Sep 2014 13:34:14 -0400
In-Reply-To: <20140913221318.13646.90438.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Subject: [PATCH 19/34] resize2fs: convert fs to and from 64bit mode
> From: darrick.wong@oracle.com
> To: tytso@mit.edu; darrick.wong@oracle.com
> CC: linux-ext4@vger.kernel.org
> Date: Sat, 13 Sep 2014 15:13:18 -0700
>
> resize2fs does its magic by loading a filesystem, duplicating the
> in-memory image of that fs, moving relevant blocks out of the way of
> whatever new metadata get created, and finally writing everything back
> out to disk. Enabling 64bit mode enlarges the group descriptors,
> which makes resize2fs a reasonable vehicle for taking care of the rest
> of the bookkeeping requirements, so add to resize2fs the ability to
> convert a filesystem to 64bit mode and back.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> resize/main.c | 40 ++++++
> resize/resize2fs.8.in | 18 +++
> resize/resize2fs.c | 326 ++++++++++++++++++++++++++++++++++++++++++++++++-
> resize/resize2fs.h | 3
> 4 files changed, 379 insertions(+), 8 deletions(-)
>
>
> diff --git a/resize/main.c b/resize/main.c
> index c107028..9fea3d8 100644
> --- a/resize/main.c
> +++ b/resize/main.c
> @@ -42,7 +42,7 @@ static char *device_name, *io_options;
> static void usage (char *prog)
> {
> fprintf (stderr, _("Usage: %s [-d debug_flags] [-f] [-F] [-M] [-P] "
> - "[-p] device [new_size]\n\n"), prog);
> + "[-p] device [-b|-s|new_size]\n\n"), prog);
>
> exit (1);
> }
> @@ -200,7 +200,7 @@ int main (int argc, char ** argv)
> if (argc && *argv)
> program_name = *argv;
>
> - while ((c = getopt (argc, argv, "d:fFhMPpS:")) != EOF) {
> + while ((c = getopt(argc, argv, "d:fFhMPpS:bs")) != EOF) {
> switch (c) {
> case 'h':
> usage(program_name);
> @@ -226,6 +226,12 @@ int main (int argc, char ** argv)
> case 'S':
> use_stride = atoi(optarg);
> break;
> + case 'b':
> + flags |= RESIZE_ENABLE_64BIT;
> + break;
> + case 's':
> + flags |= RESIZE_DISABLE_64BIT;
> + break;
> default:
> usage(program_name);
> }
> @@ -389,6 +395,10 @@ int main (int argc, char ** argv)
> if (sys_page_size> fs->blocksize)
> new_size &= ~((sys_page_size / fs->blocksize)-1);
> }
> + /* If changing 64bit, don't change the filesystem size. */
> + if (flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)) {
> + new_size = ext2fs_blocks_count(fs->super);
> + }
> if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
> EXT4_FEATURE_INCOMPAT_64BIT)) {
> /* Take 16T down to 2^32-1 blocks */
> @@ -440,7 +450,31 @@ int main (int argc, char ** argv)
> fs->blocksize / 1024, new_size);
> exit(1);
> }
> - if (new_size == ext2fs_blocks_count(fs->super)) {
> + if ((flags & RESIZE_DISABLE_64BIT) && (flags & RESIZE_ENABLE_64BIT)) {
> + fprintf(stderr, _("Cannot set and unset 64bit feature.\n"));
> + exit(1);
> + } else if (flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)) {
> + new_size = ext2fs_blocks_count(fs->super);


Redundant to assignment just above? 		 	   		  