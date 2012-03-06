From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ext4: Remove empty index blocks when punching holes
Date: Tue, 06 Mar 2012 11:42:21 -0700
Message-ID: <4F565A8D.90009@linux.vnet.ibm.com>
References: <1330501048-14109-1-git-send-email-achender@linux.vnet.ibm.com> <alpine.LFD.2.00.1202290841310.4926@dhcp-27-109.brq.redhat.com> <4F4DDE8D.6020203@linux.vnet.ibm.com> <alpine.LFD.2.00.1202290916590.4926@dhcp-27-109.brq.redhat.com> <20120305235430.GA12796@thunk.org> <alpine.LFD.2.00.1203060810430.5085@dhcp-27-109.brq.redhat.com> <20120306164412.GD32282@thunk.org> <4F565962.1020604@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44267 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757774Ab2CFSmo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2012 13:42:44 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Tue, 6 Mar 2012 13:42:43 -0500
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 301C76E8058
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 13:42:28 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q26IgSpa306194
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 13:42:28 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q26IgRLH003028
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 13:42:27 -0500
In-Reply-To: <4F565962.1020604@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/06/2012 11:37 AM, Allison Henderson wrote:
> On 03/06/2012 09:44 AM, Ted Ts'o wrote:
>> On Tue, Mar 06, 2012 at 08:11:37AM +0100, Lukas Czerner wrote:
>>>
>>> you're right my patches solves this problem (as I wrote in the commit
>>> description) just because we now use a different code paths, which do
>>> not have this problem.
>>
>> Ok, thanks. I'll look at them before the end of this week.
>>
>> Just to be clear, have the problematic code paths been removed in your
>> patches, or are they not just being used in the problem scenario?
>> Basically, is there any other time where we might need the additional
>> logic which Allison added?
>>
>> - Ted
>>
>
> Hi Ted,
>
> I think we will be ok with out this patch if we pick up Lukas's patches.
> Since the new implementation is seated inside ext4_ext_remove_space,
> Lukas can take advantage of the existing code there.
>
> In the current solution, we are seated inside map blocks, and then call
> ext4_ext_rm_leaf from there. The bug in the current solution was that we
> needed to free index blocks in the path to the extent we just removed,
> but ext4_ext_remove_space will do this as it walks over the tree.
>
> There are some things in the new implementation that Lukas and I are
> looking at, but once we get it straightened out, I think it will be ok
> to let this patch go. Thx!
>
> Allison Henderson
>

forgot to reply to all.  Resending to keep everyone posted :)

