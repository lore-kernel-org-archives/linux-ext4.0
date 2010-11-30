From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 08/15] libext2fs: fix memory leak on error path
Date: Tue, 30 Nov 2010 13:23:59 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011301318490.3004@dhcp-lab-213.englab.brq.redhat.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com> <1291020917-8671-9-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab0K3MYE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Nov 2010 07:24:04 -0500
In-Reply-To: <1291020917-8671-9-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 29 Nov 2010, Namhyung Kim wrote:

> io->name should be freed if ext2fs_file_open2() fails.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  lib/ext2fs/inode_io.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/ext2fs/inode_io.c b/lib/ext2fs/inode_io.c
> index 4faaa48..bc934d3 100644
> --- a/lib/ext2fs/inode_io.c
> +++ b/lib/ext2fs/inode_io.c
> @@ -157,11 +157,13 @@ static errcode_t inode_open(const char *name, int flags, io_channel *channel)
>  				   &data->inode : 0, open_flags,
>  				   &data->file);
>  	if (retval)
> -		goto cleanup;
> +		goto cleanup_name;
>  
>  	*channel = io;
>  	return 0;
>  
> +cleanup_name:
> +	ext2fs_free_mem(&io->name);
>  cleanup:
>  	if (data) {
>  		ext2fs_free_mem(&data);
> 

Hmm, are those check-on-free everywhere really necessary ? Would not
make more sense to check it in ext2fs_free_mem and then when we hit
things like this patch is trying to fix, just remove the conditions ?

I am not suggesting anything like "go through all e2fsprogs and change
the conditions on free", but really change it when we poke the code anyway.

-Lukas
