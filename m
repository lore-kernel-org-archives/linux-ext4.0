From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/2] ext4: Add pollable sysfs entry for block
 threshold events
Date: Wed, 18 Mar 2015 11:20:42 -0700
Message-ID: <20150318182042.GA23605@infradead.org>
References: <1426512329-24299-1-git-send-email-b.michalska@samsung.com>
 <20150316132843.GA8188@infradead.org>
 <550945D5.4060805@samsung.com>
 <alpine.LFD.2.00.1503181059150.23465@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Beata Michalska <b.michalska@samsung.com>,
	Christoph Hellwig <hch@infradead.org>,
	adilger.kernel@dilger.ca, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kyungmin.park@samsung.com
To: Luk?? Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1503181059150.23465@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 18, 2015 at 11:12:24AM +0100, Luk?? Czerner wrote:
> As Jan already mentioned the problem with quota is that it really
> is accounting for used space per user, which is not really ideal for
> this scenario. I have not seen the tmpfs discussions so maybe
> they have a solution ?
> 
> Also, implementing noenforce should should be relatively easy.

I'm not sayin we should use quota here, just a simimilar mechnisms for
reporting that we hit the space limits.
