From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [next-20101038] Call trace in ext4
Date: Thu, 28 Oct 2010 13:16:41 -0500
Message-ID: <4CC9BE09.4060003@redhat.com>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com> <20101028175221.GA1578@arch.trippelsdorf.de> <20101028180118.GC6814@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Ted Ts'o" <tytso@mit.edu>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	sedat.dilek@gmail.com, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, sfr@canb.auug.org.au,
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321Ab0J1SRG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Oct 2010 14:17:06 -0400
In-Reply-To: <20101028180118.GC6814@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o wrote:
> On Thu, Oct 28, 2010 at 07:52:21PM +0200, Markus Trippelsdorf wrote:
>> The same BUG (inode.c:2721) happend here today running latest vanilla
>> git. There is nothing in my logs unfortunately, but I shot a photo of
>> the trace (see attachment).
> 
> I see, it's the page_buffers() call which is triggering.  Looking into
> it...
> 
> 							- Ted

Same bug that Avinash Kurup reported, right.

-Eric
