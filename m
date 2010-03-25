From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: New compiler warning in 2.6.34-rc1: 'start_ext.ee_block' may
 be used uninitialized
Date: Thu, 25 Mar 2010 11:42:54 +0900
Message-ID: <4BAACDAE.7010901@rs.jp.nec.com>
References: <4B9E475F.1010302@s5r6.in-berlin.de> <20100315154142.GB4484@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:48027 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab0CYCni (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Mar 2010 22:43:38 -0400
In-Reply-To: <20100315154142.GB4484@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


(2010/03/16 0:41), tytso@mit.edu wrote:
> On Mon, Mar 15, 2010 at 03:42:39PM +0100, Stefan Richter wrote:
>> Hi,
>>
>> I saw the following scroll by during kernel compilation:
>>
>> fs/ext4/move_extent.c: In function 'mext_leaf_block':
>>
>> fs/ext4/move_extent.c:478: warning: 'start_ext.ee_block' may be used
>> uninitialized in this function
>>
>> Is it real?  It seems that the initial start_ext.ee_len = 0 guards
>> against accidental use of an uninitialized start_ext.ee_block, but maybe
>> I missed something.
>
>> From my review of the code the fact that ee_len is set to zero should
> make this be safe, but my preference would be to clear
> start_ext.ee_block as well to prevent the warning from coming up
> (since false positives clutter up warnings and might cause us to miss
> a warning which isn't so benign).
>
> Akira-san, do you agree that it is currently is safe?
>

Sorry for the late reply.

The patch (gcc-wall-cleanup-in-move_extent.c) in ext4 patch queue
looks good to me.

Thanks,
Akira Fujita
