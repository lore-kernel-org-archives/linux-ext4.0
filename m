From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 13/35] fallthru: ext2 fallthru support
Date: Wed, 21 Apr 2010 23:10:45 +0100
Message-ID: <20100421221045.GE27575@shareable.org>
References: <20100419132344.GI10776@bolzano.suse.de> <20100419133028.GA3631@shareable.org> <20100419141248.GK10776@bolzano.suse.de> <20100419142315.GA2688@shell> <E1O3sLi-0008EA-QW@pomaz-ex.szeredi.hu> <20100420213450.GM11723@shareable.org> <20100421084211.GB22741@bolzano.suse.de> <20100421092235.GB13114@shareable.org> <E1O4WKa-0003Pp-0y@pomaz-ex.szeredi.hu> <20100421213843.GE5041@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Miklos Szeredi <miklos@szeredi.hu>, jblunck@suse.de,
	dwmw2@infradead.org, viro@zeniv.linux.org.uk,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:38842 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab0DUWK7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Apr 2010 18:10:59 -0400
Content-Disposition: inline
In-Reply-To: <20100421213843.GE5041@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Valerie Aurora wrote:
> > I think there's no question that union mounts might break apps (POSIX
> > or not).  But I think there's hope that they are few and can easily be
> > fixed.
> 
> I couldn't have put it better myself.
> 
> To expand slightly, if the broken apps are not few and easily fixed,
> then we'll go back and make the kernel more complicated.  I'd like to
> try the simplest version we think will work, first.

Don't worry, I'm not trying to deviate you from that good plan.

Just throwing questions out to find what's a good and simple answer to
these little open questions to minimise trouble.

-- Jamie
