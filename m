From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Sun, 10 Aug 2014 13:47:24 -0700
Message-ID: <1407703644.8477.1.camel@jarvis.lan>
References: <CAPTn0cAKi64Fh1pAVTDLvSS5-1Kjv7KN2HpGxtm4J8-ym-4nOQ@mail.gmail.com>
	 <20140808223335.GQ25145@thunk.org>
	 <CAPTn0cCwczoaH7va4x3yJZBgtRr8b7_eG9V0YO16YzQcnshdTA@mail.gmail.com>
	 <20140809172427.GF15431@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@zeniv.linux.org.uk, hch@infradead.org,
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	"Niu, Yawei" <yawei.niu@intel.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56405 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbaHJUr1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 16:47:27 -0400
In-Reply-To: <20140809172427.GF15431@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Sat, 2014-08-09 at 13:24 -0400, Theodore Ts'o wrote:
> The last time I asked why in the world anyone would want to use this
> feature, the only use case that I heard was people who were using
> containers, and where the all of the project id's were inside a
> chroot.  Hence, any questions I asked about what happens when a file
> gets moved out from the hierarchy were hand-waved away, since inside a
> chroot, it could never happen.

Actually, I don't believe that's entirely accurate.  The performance
problem with shared filesystem roots for containers has meant OpenVZ has
been using a block root for a while.  However, we still support the old
shared filesystem root, but for quota's within the chroot, we use a subtree
quota system (not a project quota) for which Dmitry Monakhov
posted the patches several times a couple of years ago.

James


