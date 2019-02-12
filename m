Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF491C282D7
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 00:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A608C20844
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 00:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbfBLAEC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 19:04:02 -0500
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:52092 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727427AbfBLAEC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 19:04:02 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail01.adl6.internode.on.net with ESMTP; 12 Feb 2019 10:33:57 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gtLYL-0002P2-4h; Tue, 12 Feb 2019 11:03:57 +1100
Date:   Tue, 12 Feb 2019 11:03:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-api@vger.kernel.org,
        keyrings@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: Re: [RFC PATCH v2 11/20] fscrypt: add FS_IOC_REMOVE_ENCRYPTION_KEY
 ioctl
Message-ID: <20190212000357.GI20493@dastard>
References: <20190211172738.4633-1-ebiggers@kernel.org>
 <20190211172738.4633-12-ebiggers@kernel.org>
 <20190211221249.GH20493@dastard>
 <20190211233128.GB226227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211233128.GB226227@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Feb 11, 2019 at 03:31:29PM -0800, Eric Biggers wrote:
> Hi Dave,
> 
> On Tue, Feb 12, 2019 at 09:12:49AM +1100, Dave Chinner wrote:
> > On Mon, Feb 11, 2019 at 09:27:29AM -0800, Eric Biggers wrote:
> > 
> > Indeed, this is exactly what ->drop_inode() is for.
> > 
> > Take this function:
> > 
> > > +static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
> > > +{
> > > +	struct fscrypt_info *ci;
> > > +	struct inode *inode;
> > > +	struct inode *toput_inode = NULL;
> > > +
> > > +	spin_lock(&mk->mk_decrypted_inodes_lock);
> > > +
> > > +	list_for_each_entry(ci, &mk->mk_decrypted_inodes, ci_master_key_link) {
> > > +		inode = ci->ci_inode;
> > > +		spin_lock(&inode->i_lock);
> > > +		if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
> > > +			spin_unlock(&inode->i_lock);
> > > +			continue;
> > > +		}
> > > +		__iget(inode);
> > > +		spin_unlock(&inode->i_lock);
> > > +		spin_unlock(&mk->mk_decrypted_inodes_lock);
> > > +
> > > +		shrink_dcache_inode(inode);
> > > +		iput(toput_inode);
> > > +		toput_inode = inode;
> > > +
> > > +		spin_lock(&mk->mk_decrypted_inodes_lock);
> > > +	}
> > > +
> > > +	spin_unlock(&mk->mk_decrypted_inodes_lock);
> > > +	iput(toput_inode);
> > > +}
> > 
> > It takes a new reference to each decrypted inode, and then drops it
> > again after all the dentry cache references have been killed and
> > we've got a reference to the next inode in the list.  Killing the
> > dentry references to the inode means it should only have in-use
> > references and the reference this function holds on it.
> > 
> > If the inode is not in use then there will be only one, and so it
> > will fall into iput_final() and the ->drop_inode() function
> > determines if the inode should be evicted from the cache and
> > destroyed immediately.  IOWs, implement fscrypt_drop_inode() to do
> > the right thing when the key has been destroyed, and you can get rid
> > of all this crazy inode cache walk-and-invalidate hackery.
> > 
> 
> Thanks for the feedback!  If I understand correctly, your suggestion is:
> 
> - Keep evict_dentries_for_decrypted_inodes() as-is, i.e. fscrypt would still
>   evict the dentries for all inodes in ->mk_decrypted_inodes.
>   (I don't see how it could work otherwise.)
> 
> - However, evict_decrypted_inodes() would be removed and fscrypt would not
>   directly evict the list of inodes.  Instead, the filesystem's ->drop_inode()
>   would be made to return 1 if the inode's master key has been removed.  Thus
>   each inode, if no longer in use, would end up getting evicted during the
>   iput() in evict_dentries_for_decrypted_inodes().

*nod*

> I hadn't thought of this, and I think it would work; I'll try implementing it.
> It would also have the advantage that if a key is removed while an inode is
> still in-use, that inode will be evicted as soon as it's no longer in use rather
> than waiting around until another FS_IOC_REMOVE_ENCRYPTION_KEY.

*nod*

> The ioctl will need a different way to determine whether any inodes couldn't be
> evicted, but simply checking whether ->mk_decrypted_inodes ended up empty or not
> should work.

*nod*

> FWIW, originally I also considered leaving the inodes in the inode cache and
> instead only freeing ->i_crypt_info and truncating the pagecache.  But I don't
> see a way to do it even with this new idea; for one, ->drop_inode() is called
> under ->i_lock.  So it seems that eviction is still the way to go.

Yeah, eviction is by far the easiest way to deal with this. If it's
being frequently referenced/written, the backing buffer should be in
memory anyway and the next access simply has to re-instantiate the
inode cache from the buffer and won't need to do IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
