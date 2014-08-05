From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: After unlinking a large file on ext4, the process stalls for a long time
Date: Tue, 5 Aug 2014 23:54:35 +0200
Message-ID: <DE44CAD2-9FB4-4D46-A381-BFB00D39B607@dilger.ca>
References: <53C6B38A.3000100@free.fr> <59C3F41A-6AFD-418E-BCE6-2361B8140D9A@dilger.ca> <53C7A5CA.4050903@free.fr> <alpine.LFD.2.00.1407171238060.2312@localhost.localdomain> <53C7B0B7.9030007@free.fr> <20140717133755.GN1491@thunk.org> <53C7F4C2.6070804@free.fr> <alpine.LFD.2.00.1407181127440.12453@localhost.localdomain> <53DF9918.3010206@free.fr> <6910CF48-15F8-4218-8881-06899D7C56A5@dilger.ca> <20140805023300.GE5263@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Mason <mpeg.blue@free.fr>,
	=?utf-8?Q?Luk=C3=A1=C5=A1_Czerner?= <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:55770 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaHEVyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Aug 2014 17:54:40 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so7738490wib.9
        for <linux-ext4@vger.kernel.org>; Tue, 05 Aug 2014 14:54:39 -0700 (PDT)
In-Reply-To: <20140805023300.GE5263@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 5, 2014, at 4:33, Theodore Ts'o <tytso@mit.edu> wrote:
> 
>> On Tue, Aug 05, 2014 at 12:55:14AM +0200, Andreas Dilger wrote:
>> It would be possible to optimize mb_free_blocks() by having it
>> clear a whole word at a time instead of a series if bits. 
> 
> It looks like we're doing this already in mb_test_and_clear_bits(),
> aren't we?

Sorry, I didn't see mb_test_and_clear_bits(), I was only looking at
mb_clear_bit() to see if it be the multi-bit optimization. 

>> I thought that was done already, but it doesn't appear to be the case.
>> Also, it isn't clear that the bit "normalization" is needed anymore.
>> This was done back in the aniceint times when the buddy bitmaps were stored on disk instead of being regenerated only at mount time. 
> 
> I'm not sure what you mean by this; the only reference I can find
> normalization is with normalizing requests?

I meant mb_correct_addr_and_bit(). 

Cheers, Andreas