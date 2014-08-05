From: Mason <mpeg.blue@free.fr>
Subject: Re: After unlinking a large file on ext4, the process stalls for a
 long time
Date: Tue, 05 Aug 2014 14:06:03 +0200
Message-ID: <53E0C8AB.7090405@free.fr>
References: <53C687B1.30809@free.fr>
	<21446.38705.190786.631403@quad.stoffel.home> <53C6B38A.3000100@free.fr>
	<59C3F41A-6AFD-418E-BCE6-2361B8140D9A@dilger.ca> <53C7A5CA.4050903@free.fr>
	<alpine.LFD.2.00.1407171238060.2312@localhost.localdomain>
	<53C7B0B7.9030007@free.fr> <20140717133755.GN1491@thunk.org>
	<53C7F4C2.6070804@free.fr>
	<alpine.LFD.2.00.1407181127440.12453@localhost.localdomain>
	<53DF9918.3010206@free.fr> <6910CF48-15F8-4218-8881-06899D7C56A5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: =?iso-8859-2?b?THVr4bk=?= Czerner <lczerner@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp22.services.sfr.fr ([93.17.128.11]:26439 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaHEMGF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Aug 2014 08:06:05 -0400
In-Reply-To: <6910CF48-15F8-4218-8881-06899D7C56A5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/08/2014 00:55, Andreas Dilger wrote:

> It would be possible to optimize mb_free_blocks() by having it
> clear a whole word at a time instead of a series of bits.
> 
> I thought that was done already, but it doesn't appear to be the case.
> Also, it isn't clear that the bit "normalization" is needed anymore.
> This was done back in the ancient times when the buddy bitmaps were
> stored on disk instead of being regenerated only at mount time.

Are there any other tests you'd like me to run?
(I will be permanently losing access to this platform in a few days.)

-- 
Regards.
