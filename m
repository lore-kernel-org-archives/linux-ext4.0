From: Ron Johnson <ron.l.johnson@cox.net>
Subject: Re: ext5
Date: Thu, 11 Feb 2010 22:47:15 -0600
Message-ID: <4B74DD53.3080308@cox.net>
References: <20100210215028.GD739@thunk.org> <4B73931D.5000302@cox.net>	<20100211064433.GF739@thunk.org> <874olnih62.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eastrmmtao102.cox.net ([68.230.240.8]:34813 "EHLO
	eastrmmtao102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab0BLErQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Feb 2010 23:47:16 -0500
Received: from eastrmimpo02.cox.net ([68.1.16.120])
          by eastrmmtao102.cox.net
          (InterMail vM.8.00.01.00 201-2244-105-20090324) with ESMTP
          id <20100212044716.YEGN13474.eastrmmtao102.cox.net@eastrmimpo02.cox.net>
          for <linux-ext4@vger.kernel.org>; Thu, 11 Feb 2010 23:47:16 -0500
In-Reply-To: <874olnih62.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-02-11 15:41, Goswin von Brederlow wrote:
> tytso@mit.edu writes:
>> The idea with read-only compressed files is that they are useful for
>> large executables or large static files, where compressing them means
>> that it takes less time to read them off of an HDD.
> 
> Or when you only have so much flash.

Isn't that what squashfs is for?

-- 
"Hell hath no fury like the vast robot armies of a woman scorned."
Walt
