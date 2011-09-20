From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/3] VFS: Fix s_umount thaw/write deadlock
Date: Tue, 20 Sep 2011 18:51:11 -0400
Message-ID: <20110920225111.GA28293@infradead.org>
References: <CAD-Xujmjai2evYC4a4CdNPtjh_9xhbELcZePtGSS54VPRGpznA@mail.gmail.com>
 <CAD-Xujm87Aj6y09GRXPVMZM+9N_7wyte-YNp7t0Wi3R2qH2mHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Valerie Aurora <val@vaaconsulting.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40629
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643Ab1ITWvR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Sep 2011 18:51:17 -0400
Content-Disposition: inline
In-Reply-To: <CAD-Xujm87Aj6y09GRXPVMZM+9N_7wyte-YNp7t0Wi3R2qH2mHQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 12, 2011 at 07:57:11PM -0700, Valerie Aurora wrote:
> 

Can you please resend the series in proper format, that is inlined,
with the subject in the mail header and just the description and the
patch itself in the body?

The current form is not really reviewable.
