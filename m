From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and i_generation available by xattrs
Date: Mon, 28 Jun 2010 13:08:41 -0600
Message-ID: <19AAF9AA-2445-4C73-808B-4AD9C5C7E769@dilger.ca>
References: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: viro@ZenIV.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
	mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
	sjayaraman@suse.de, linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:9483 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab0F1TJP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jun 2010 15:09:15 -0400
In-Reply-To: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-06-28, at 10:26, David Howells wrote:
> Make the file creation time, inode data version number and inode generation
> number available on Ext4 by as xattrs named:
> 
> 	file.crtime
> 	file.i_generation
> 	file.i_version (directories only for ext4)

Some minor nits:
- I'd prefer calling these "file.generation" and "file.version".
  I don't think there is value in the "i_" prefix adds anything,
  and it seems more like an internal detail to me
- why not expose the ".version" field for regular files?  It seems
  that all of them are applicable for all file types.
- it would be good to not introduce a new xattr namespace, since
  tools like tar (even the RHEL-patched one) will not backup and
  restore these namespaces.  Using "trusted." would allow them to
  be backed up and restored using existing xattr-patched GNU tar
  by root, but wouldn't allow them to be modified by regular users.
  I think this is important for proper backup/restore of a filesystem,
  but can have correctness implications and shouldn't be accessible
  to regular users.

> file.crtime=0x53ba244c000000000000000000000000

Is this a binary (host-endian) struct timespec?

> file.i_generation=0x0000000000000000

This seems odd, i_generation should never be zero, AFAIK.

Cheers, Andreas





