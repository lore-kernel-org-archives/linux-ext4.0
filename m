From: "Bojan Smojver" <bojan@rexursive.com>
Subject: Re: [linux-pm] Oops while going into hibernate
Date: Sat, 15 Jan 2011 00:14:10 +1100
Message-ID: <4204848083.979517650@rexursive.com>
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6> <20110112162655.GA13496@thunk.org> <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6> <20110112172646.GB13496@thunk.org> <alpine.LFD.2.02.1101121934060.2011@localhost6.localdomain6> <A01161D0-D08F-4522-A546-90057B2E1F2A@mit.edu> <alpine.LFD.2.02.1101131238480.1899@localhost6.localdomain6> <20110113133612.GD2534@osiris.boeblingen.de.ibm.com> <20110113184626.GA31800@thunk.org> <1294954212.2781.8.camel@shrek.rexursive.com> <20110114095321.GA2696@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Cc: tytso@mit.edu, linux-pm@lists.linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: heiko.carstens@de.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from beauty.rexursive.com ([150.101.121.179]:48852 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab1ANNOT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Jan 2011 08:14:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> However since s390 is the only architecture which has dirty bits for
> physical pages I doubt that there is any such code present. So the
> bug should happen independently of image compression.

Ah, sorry - I wasn't clear there. I meant for other archs, where setting 
the dirty bit on read may matter when compression is off.

Obviously, s390 will have to have its own problem fixed separately.

--
Bojan 
