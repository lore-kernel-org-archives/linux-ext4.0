From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: ext4_mknod: always set i_op
Date: Wed, 26 Sep 2012 21:25:35 -0400
Message-ID: <20120927012535.GA28586@thunk.org>
References: <504782F8.2080005@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52607 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737Ab2I0BZj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 21:25:39 -0400
Content-Disposition: inline
In-Reply-To: <504782F8.2080005@itwm.fraunhofer.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 05, 2012 at 06:51:04AM -0000, Bernd Schubert wrote:
> While I was looking through the code, I noticed i_op 
> is not always initialized, although operations such 
> as setattr probably always should be set.
> 
> 
> ext4: ext4_mknod:  always set i_op
> 
> From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
> 
> ext4_special_inode_operations have their own ifdef CONFIG_EXT4_FS_XATTR
> to mask those methods. And ext4_iget also always sets it, so there is
> an inconsistency.
> 
> Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

Applied, thanks!!

						- Ted
