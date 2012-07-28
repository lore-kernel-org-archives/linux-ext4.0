From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e4defrag: Handle device symlinks
Date: Sat, 28 Jul 2012 17:54:09 -0400
Message-ID: <20120728215409.GH659@thunk.org>
References: <500859C6.6040401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Kazuya Mio <k-mio@sx.jp.nec.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41851 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab2G1VyN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Jul 2012 17:54:13 -0400
Content-Disposition: inline
In-Reply-To: <500859C6.6040401@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 19, 2012 at 02:02:30PM -0500, Eric Sandeen wrote:
> Device nodes are commonly accessed via symlinks, i.e.
> 
> # ls -l /dev/mapper/testvg-testlv 
> lrwxrwxrwx. 1 root root 7 Jul 19 13:01 /dev/mapper/testvg-testlv -> ../dm-0
> 
> Today, e4defrag on such a device will fail:
> 
> # e4defrag -c /dev/mapper/testvg-testlv 
> File is not regular file
>  "/dev/mapper/testvg-testlv"
> 
> due to it being a link, and e4defrag on the link target does as well:
> 
> # e4defrag -c /dev/dm-0 
> Filesystem is not mounted
> 
> due to the target not being found in /etc/mtab.
> 
> Fix this by checking whether the symlink target is a block device
> and if so, using that device in main(), and also changing get_mount_point()
> to search for a matching device number, not device name.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
