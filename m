From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext4_inode difference between e2fsprogs and ext4
Date: Thu, 11 Oct 2007 03:19:48 -0600
Message-ID: <20071011091948.GQ8122@schatzie.adilger.int>
References: <470DE640.3040101@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:45269 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259AbXJKJTu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 05:19:50 -0400
Content-Disposition: inline
In-Reply-To: <470DE640.3040101@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 11, 2007  14:30 +0530, Aneesh Kumar K.V wrote:
> In ext4 we have
> 
>  union { 
>                struct {
>                        __le16  l_i_reserved1;  /* Obsoleted fragment 
>                        number/size which are removed in ext4 */
>                        __le16  l_i_file_acl_high;
>                        __le16  l_i_uid_high;   /* these 2 fields */
>                        __le16  l_i_gid_high;   /* were reserved2[0] */
>                        __u32   l_i_reserved2;
>                } linux2;
> 
> 
> Last week we were discussing about taking that l_i_reserved1 and using that 
> for making file_acl 64 bit and using the lower l_i_reserved2 for 64 bit dir_acl. 

We have l_i_file_acl_high already to give us 48-bit i_file_acl, which is
sufficient, IMHO.  There is no need to have a larger i_dir_acl since this
field is only really used for i_size_high and should be renamed as such
instead of just being a macro.

> Now where will i put l_i_blocks_hi ?

Just where it is now - in l_i_reserved1...

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
