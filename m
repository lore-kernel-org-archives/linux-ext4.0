From: Andi Kleen <andi@firstfloor.org>
Subject: Re: ext3 default journal mode
Date: Tue, 21 Jul 2009 00:58:48 +0200
Message-ID: <87iqhn2c7r.fsf@basil.nowhere.org>
References: <4A63DB89.2060306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Valerie Aurora <vaurora@redhat.com>,
	"Stephen C. Tweedie" <sct@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:46406 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbZGTW6v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jul 2009 18:58:51 -0400
In-Reply-To: <4A63DB89.2060306@redhat.com> (Ric Wheeler's message of "Sun, 19 Jul 2009 22:50:49 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ric Wheeler <rwheeler@redhat.com> writes:
>
> As I mentioned in an earlier email, I think *every* distribution undid
> this default back to ordered mode.

I would agree too that the default should be changed again. 

Shortly after the default was changed to writeback
I had a (unrelated crash) and afterwards had to fix up several
files in the file system manually that contained junk. Never
has happened before with ordered.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
