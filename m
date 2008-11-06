From: "Roc Valles" <vallesroc@gmail.com>
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Thu, 6 Nov 2008 09:00:54 +0000
Message-ID: <3d3ce57e0811060100l6919de94n5e45b66f49e118f9@mail.gmail.com>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com>
	 <20081103134008.GE29102@mit.edu>
	 <319012f0811050534i27b7dce1t8120b3a343844adc@mail.gmail.com>
	 <20081105172553.GA29880@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: cryptooctoploid@gmail.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:9008 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbYKFJA4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 04:00:56 -0500
Received: by fg-out-1718.google.com with SMTP id 19so357144fgg.17
        for <linux-ext4@vger.kernel.org>; Thu, 06 Nov 2008 01:00:54 -0800 (PST)
In-Reply-To: <20081105172553.GA29880@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As we talked in #ext4, I've downloaded that big torrent (14GB) with
nodelalloc. Hash check was fine for such a big torrent which also had
so many peers, so I'm inclined to think that nodelalloc does indeed
make the problem go away.

Whatever's wrong, it's definitively delalloc-related.
