From: Andi Kleen <andi@firstfloor.org>
Subject: Re: What happened to data=guarded?
Date: Tue, 11 Aug 2009 17:29:14 +0200
Message-ID: <878whqgyid.fsf@basil.nowhere.org>
References: <1249934623-15939-1-git-send-email-tytso@mit.edu>
	<200908111535.37927.elendil@planet.nl> <20090811133721.GD29224@think>
	<200908111654.38217.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Frans Pop <elendil@planet.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:59299 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbZHKP3O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 11:29:14 -0400
In-Reply-To: <200908111654.38217.elendil@planet.nl> (Frans Pop's message of "Tue, 11 Aug 2009 16:54:36 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Frans Pop <elendil@planet.nl> writes:

> On Tuesday 11 August 2009, Chris Mason wrote:
>> On Tue, Aug 11, 2009 at 03:35:36PM +0200, Frans Pop wrote:
>> > Somewhat unrelated, but what happened to the data=guarded patches
>> > Chris Mason proposed back in April?
>>
>> I missed 2.6.31 but plan on sending for 2.6.32.  I promised to send
>> along a forward port of the patches a while back, but I finally have
>> one in testing here.  It should go out shortly.
>
> Good to hear. I've so far stayed with data=ordered as I think I'd prefer 
> data=guarded over data=writeback. I'll certainly give it a try when it's 
> available.

Same here. data=writeback already cost me a few files after crashes here :/

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
