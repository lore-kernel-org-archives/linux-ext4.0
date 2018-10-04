Return-Path: <SRS0=Op7R=MQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56850 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbeJDV3Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 4 Oct 2018 17:29:24 -0400
Date: Thu, 4 Oct 2018 10:35:38 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH] mm: Fix warning in insert_pfn()
Message-ID: <20181004143538.GE646@thunk.org>
References: <20180824154542.26872-1-jack@suse.cz>
 <20181003163557.GA18434@thunk.org>
 <CAPcyv4hxxcC6dkeN80MXaHx9A-kw1fn=Yjqi5uGRdFueVRFXbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hxxcC6dkeN80MXaHx9A-kw1fn=Yjqi5uGRdFueVRFXbg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 03, 2018 at 09:56:09AM -0700, Dan Williams wrote:
> 
> It's in Andrew's tree. I believe we are awaiting the next -next
> release to rebase on latest mmotm.

Great, thanks for the update!

					- Ted
