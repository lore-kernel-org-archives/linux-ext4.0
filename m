From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4: Do not dec quota for reserved blocks on error paths v2
Date: Wed, 05 May 2010 10:51:56 -0500
Message-ID: <4BE1941C.2050907@redhat.com>
References: <87633dcxhp.fsf@openvz.org> <87bpd3ecya.fsf@openvz.org>	<4BE08215.2050603@redhat.com> <87wrvihlr5.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab0EEPwA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 May 2010 11:52:00 -0400
In-Reply-To: <87wrvihlr5.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/05/2010 02:05 AM, Dmitry Monakhov wrote:
> Eric Sandeen <sandeen@redhat.com> writes:

...

>>> The bug happens on heavily loaded node, or with 227'th xfstestcase and
>>
>> hm which test?  227 is xfs-only...
> Oh.. it has that number at the time i've posted it, and it wasn't
> merged yet.
> http://marc.info/?l=linux-ext4&m=127124399930095&w=2
> You have already requested some cleanups, so i'll post new version,
> under new number, soon.

Oh ok, sorry!  I lost track.

-Eric
