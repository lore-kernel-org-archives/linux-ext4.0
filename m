From: Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH] ext4: fix warning in ext4_da_update_reserve_space()
Date: Tue, 27 Jan 2015 18:14:41 -0600
Message-ID: <54C829F1.8040905@akamai.com>
References: <1420750108-11512-1-git-send-email-johunt@akamai.com>
 <20150128001237.GC17677@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>
To: Greg KH <greg@kroah.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:46919 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755039AbbA1ARS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2015 19:17:18 -0500
In-Reply-To: <20150128001237.GC17677@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/27/2015 06:12 PM, Greg KH wrote:
> On Thu, Jan 08, 2015 at 03:48:28PM -0500, Josh Hunt wrote:
>>      Please add the patch below and referenced dependency (0e95c22) to stable
>>      3.10.y. The original 7d73453 did not apply cleanly to my 3.10.y so I've
>>      backported it here. Its dependency can be cherry-picked.
>
> The dependancy was 1c8924eb106c1ac755d5d35ce9b3ff42e89e2511, there is
> no "0e95c22" in Linus's tree :(
>

Yeah, sorry. I sent a correction, but maybe it slipped through the cracks.

Josh
