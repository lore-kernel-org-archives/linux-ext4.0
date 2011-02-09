From: Tao Ma <tm@tao.ma>
Subject: [PATCH 0/4] EXT4 trim bug fixes and improvement.
Date: Wed, 09 Feb 2011 13:52:27 +0800
Message-ID: <4D522B9B.5070707@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:57702 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751071Ab1BIFwg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Feb 2011 00:52:36 -0500
Received: from [114.251.86.0] (helo=[10.32.105.66])
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <tm@tao.ma>)
	id 1Pn2yh-0002Xf-1h
	for linux-ext4@vger.kernel.org; Tue, 08 Feb 2011 22:52:35 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted and the list,
     Here are 4 patches for trim support in ext4.
     Patch 1/4 is a fix for the 'len' overflow. As we have decided that 
we don't adjust start to s_first_data_block, this patch is still needed.
     Patch 2/4 is a speedup for trim in one group.
     Patch 3/4 adds trace points for the functions used in FITRIM.
     Patch 4/4 is a speedup for trim in the whole volume. For more 
details, please check the commit log.

Regards,
Tao
