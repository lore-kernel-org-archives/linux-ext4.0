From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: regressions due to 64-bit ext4 directory cookies
Date: Tue, 12 Feb 2013 21:56:41 +0100
Message-ID: <511AAC89.3060409@itwm.fraunhofer.de>
References: <20130212202841.GC10267@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com,
	Theodore Ts'o <tytso@mit.edu>, gluster-devel@nongnu.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60516 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757234Ab3BLU4o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Feb 2013 15:56:44 -0500
In-Reply-To: <20130212202841.GC10267@fieldses.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/12/2013 09:28 PM, J. Bruce Fields wrote:
> 06effdbb49af5f6c "nfsd: vfs_llseek() with 32 or 64 bit offsets (hashes)"
> and previous patches solved problems with hash collisions in large
> directories by using 64- instead of 32- bit directory hashes in some
> cases.  But it caused problems for users who assume directory offsets
> are "small".  Two cases we've run across:
> 
> 	- older NFS clients: 64-bit cookies cause applications on many
> 	  older clients to fail.
> 	- gluster: gluster assumed that it could take the top bits of
> 	  the offset for its own use.
> 
> In both cases we could argue we're in the right: the nfs protocol
> defines cookies to be 64 bits, so clients should be prepared to handle
> them (remapping to smaller integers if necessary to placate applications
> using older system interfaces).  And gluster was incorrect to assume
> that the "offset" was really an "offset" as opposed to just an opaque
> value.
> 
> But in practice things that worked fine for a long time break on a
> kernel upgrade.
> 
> So at a minimum I think we owe people a workaround, and turning off
> dir_index may not be practical for everyone.
> 
> A "no_64bit_cookies" export option would provide a workaround for NFS 
> servers with older NFS clients, but not for applications like gluster.
> 
> For that reason I'd rather have a way to turn this off on a given ext4 
> filesystem.  Is that practical?

I think Ted needs to answer if he would accept another mount option. But
before we are going this way, what is gluster doing if there are hash
collions?

Thanks,
Bernd
