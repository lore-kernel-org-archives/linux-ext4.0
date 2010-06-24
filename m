From: tytso@mit.edu
Subject: Re: Next3 on-disk format change request
Date: Wed, 23 Jun 2010 20:35:29 -0400
Message-ID: <20100624003529.GF6843@thunk.org>
References: <AANLkTikAoKpZNGvtyYscPLVH1HrW3xaCZ84sVc62UGD4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42365 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab0FXAfe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jun 2010 20:35:34 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTikAoKpZNGvtyYscPLVH1HrW3xaCZ84sVc62UGD4@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 22, 2010 at 01:30:54PM +0300, Amir Goldstein wrote:
> My on-disk format change request is to re-assign a ro_compat feature
> for IS_SNAPSHOT (currently in s_flags).

OK, so in addition to:

#define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x0080

You would also like:

#define EXT4_FEATURE_RO_COMPAT_IS_SNAPSHOT	0x0100

which is a feature flag that the kernel will never support, since this
is a hint that snapshot should only be mounted read-only, correct?

						- Ted
