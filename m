From: Solofo.Ramangalahy@bull.net
Subject: Re: jbd/jbd2 performance improvements
Date: Thu, 16 Oct 2008 08:04:19 +0200
Message-ID: <18678.55651.556822.187508@frecb006361.adech.frec.bull.fr>
References: <E1KnCO6-0001qG-SV@closure.thunk.org>
	<48F62893.9060606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59463 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbYJPGHu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Oct 2008 02:07:50 -0400
In-Reply-To: <48F62893.9060606@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ric,

>>>>> On Wed, 15 Oct 2008 13:29:55 -0400, Ric Wheeler <rwheeler@redhat.com> said:
    Ric> We are going to try and poke at this - do you suspect a single or 
    Ric> multi-threaded test would work best?

I've performed some tests:
http://www.bullopensource.org/ext4/20081013-2.6.27-rc9-ext4-1-akpm-fix-run6/
http://www.bullopensource.org/ext4/20081013-2.6.27-rc9-ext4-1-akpm-fix-run6/results_sorted.txt.html

I now realize that the results may not be valid since I used kvm, but
they do show variation wrt. the number of threads.

So you may want to test both single and multi-threaded.

-- 
solofo
