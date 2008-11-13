From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] filesystems: use has_capability_noaudit interface for
 reserved blocks checks
Date: Thu, 13 Nov 2008 14:53:16 -0800
Message-ID: <20081113145316.e53858bd.akpm@linux-foundation.org>
References: <1226430769.3353.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, sct@redhat.com, adilger@sun.com,
	tytso@mit.edu, linux-ext4@vger.kernel.org, dedekind@infradead.org,
	ext-adrian.hunter@nokia.com, linux-mtd@lists.infradead.org,
	dushistov@mail.ru, jmorris@namei.org
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601AbYKMW4J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2008 17:56:09 -0500
In-Reply-To: <1226430769.3353.5.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 11 Nov 2008 14:12:49 -0500
Eric Paris <eparis@redhat.com> wrote:

> ext[2,3,4], ufs, and ubifs all check for  CAP_SYS_RESOURCE to determine
> if they should allow reserved blocks to be used.  A process not having
> this capability is not failing some security decision and should not be
> audited.  Thus move to using has_capability_noaudit.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
> 
> I would like to push this patch through the security tree (since that's
> the only place the new cap_noaudit interface exists), but I'd like to
> get an ACK from each subsystem maintainer.

OK by me.

Whoever added has_capability_noaudit() forgot to document it, so the
difference between has_capability_noaudit() and has_capability() eludes
this reader.

