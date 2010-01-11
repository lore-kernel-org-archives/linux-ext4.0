From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Size of journal?
Date: Sun, 10 Jan 2010 23:06:16 -0600
Message-ID: <4B4AB1C8.3050601@redhat.com>
References: <4B4A228F.4000205@att.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jeff Layton <laytonjb@att.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab0AKFGU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jan 2010 00:06:20 -0500
In-Reply-To: <4B4A228F.4000205@att.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeff Layton wrote:
> Good afternoon!
> 
> I was wondering what the default journal size is for ext4
> when it's built on a single partition? Or does it vary in size
> as needed?
> 
> TIA!
> 
> Jeff

See figure_journal_size() in mke2fs.c.  It's called w/ size == -1
if no other size is specified on the commandline so that goes
to ext2fs_default_journal_size(), which is pretty straightforward
in its scaling with nr of filesystem blocks:

/*
 * Find a reasonable journal file size (in blocks) given the number of blocks
 * in the filesystem.  For very small filesystems, it is not reasonable to
 * have a journal that fills more than half of the filesystem.
 */
int ext2fs_default_journal_size(__u64 blocks)
{
        if (blocks < 2048)
                return -1;
        if (blocks < 32768)
                return (1024);
        if (blocks < 256*1024)
                return (4096);
        if (blocks < 512*1024)
                return (8192);
        if (blocks < 1024*1024)
                return (16384);
        return 32768;
}
