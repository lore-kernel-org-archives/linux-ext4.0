From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] vfs: allow custom EOF in generic_file_llseek code
Date: Fri, 27 Apr 2012 11:28:58 -0500
Message-ID: <4F9AC94A.3070506@sandeen.net>
References: <4F9AC770.8080004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49330 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758889Ab2D0Q27 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Apr 2012 12:28:59 -0400
In-Reply-To: <4F9AC770.8080004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/27/12 11:21 AM, Eric Sandeen wrote:
> For ext3/4 htree directories, using the vfs llseek function with
> SEEK_END goes to i_size like for any other file, but in reality
> we want the maximum possible hash value.  Recent changes
> in ext4 have cut & pasted generic_file_llseek() back into fs/ext4/dir.c,
> but replicating this core code seems like a bad idea, especially
> since the copy has already diverged from the vfs.
> 
> This patch implements a version of generic_file_llseek which can accept
> both a custom maximum offset, and a custom EOF position.  With this
> in place, ext4_dir_llseek can pass in the appropriate maximum hash
> position for both maxsize and eof, and get what it wants.
> 
> As far as I know, this does not fix any bugs - nfs in the kernel
> doesn't use SEEK_END, and I don't know of any user who does.  But
> some ext4 folks seem keen on doing the right thing here, and I can't
> really argue.
> 
> (Patch also fixes up some comments slightly)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

I guess I should ahev done a patch series, although the ext4 patch is so
messy it's hard to read as a patch.  With the new framework in place,
ext4_dir_llseek can just be:

/*
 * ext4_dir_llseek() calls generic_file_llseek_size to handle htree
 * directories, where the "offset" is in terms of the filename hash
 * value instead of the byte offset.
 *
 * Because we may return a 64-bit hash that is well beyond offset limits,
 * we need to pass the max hash as the maximum allowable offset in
 * the htree directory case.
 *
 * For non-htree, ext4_llseek already chooses the proper max offset.
 */
loff_t ext4_dir_llseek(struct file *file, loff_t offset, int origin)
{
        struct inode *inode = file->f_mapping->host;
        int dx_dir = is_dx_dir(inode);
        loff_t htree_max = ext4_get_htree_eof(file);

        if (likely(dx_dir))
                return generic_file_llseek_size_eof(file, offset, origin,
                                                    htree_max, htree_max);
        else
                return ext4_llseek(file, offset, origin);
}


-Eric

