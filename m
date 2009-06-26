From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: Segmentation fault in e4defrag -c
Date: Fri, 26 Jun 2009 17:32:48 +0900
Message-ID: <4A4487B0.9080000@sx.jp.nec.com>
References: <20090625105558.GA21773@uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: a-fujita@rs.jp.nec.com, linux-ext4@vger.kernel.org
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:60613 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZFZIf1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Jun 2009 04:35:27 -0400
In-Reply-To: <20090625105558.GA21773@uio.no>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Steinar,

Thanks for testing defrag.

e4defrag -c works fine in the case without defrag patch.
I cannot reproduce this problem, so I think this problem occurred in unusual 
cases (e.g. i_size is not zeroed but it has no extent)


To solve this problem, could you send me the following information?
1. mount option of /home/sesse
2. filefrag -v "/home/sesse/Mika - Life In Cartoon Motion/11 - Ring Ring (Bonus 
Track).mp3"
3. stat "/home/sesse/Mika - Life In Cartoon Motion/11 - Ring Ring (Bonus Track).mp3"

Does this problem occur at all times?

Regards,

Kazuya Mio
