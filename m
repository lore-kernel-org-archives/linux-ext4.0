From: Theodore Tso <tytso@mit.edu>
Subject: Re: Multiple Data Stream
Date: Sun, 27 Jul 2008 19:04:55 -0400
Message-ID: <20080727230455.GE7922@mit.edu>
References: <2d08ef090807270334x4b275c21we69d0dd9fc9a460@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Rohit Sharma <imreckless@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37876 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750843AbYG0XFE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jul 2008 19:05:04 -0400
Content-Disposition: inline
In-Reply-To: <2d08ef090807270334x4b275c21we69d0dd9fc9a460@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 27, 2008 at 04:04:32PM +0530, Rohit Sharma wrote:
> Does ext2/ext3 supports multiple data streams.

No.  The primary use of alternate data streams in Windows XP has been
Virii, Trojan Horses, and Rootkits.  See this article by Rick Cook,
"Alternate Data Streams: Threat or Menace:"

       http://www.informit.com/articles/article.aspx?p=413685

(Threat or Menace?  Menance or Threat?  Or to quote Bugs Bunny/Daffy
Duck, "Would you like to shoot me now or wait till you get home?"  :-)

I've heard stories of System Administrators refusing to upgrade past
Solaris 8 because of concerns of attackers being able to use the
alternate data streams feature which Sun unfortunately added in
Solaris 9 to hide rootkits in ways that traditional scanning tools
would not be able to detect.

I've yet to see a coherent argument for why multiple data streams is
worth it....

						- Ted


Bugs Bunny: Would you like to shoot me now or wait 'til you get home?
Daffy Duck: Shoot him now! Shoot him now!
Bugs Bunny: You keep outta this! He doesn't have to shoot you now!
Daffy Duck: He does SO have to shoot me now!
[to Elmer]
Daffy Duck: I demand that you shoot me now!
[Elmer raises his gun. As Daffy sticks his tongue out at Bugs, he is shot] 


Daffy Duck: Let'th run through that again.
Bugs Bunny: Okay.
[neutral toned]
Bugs Bunny: Wouldja like to shoot me now or wait till ya get home.
Daffy Duck: [neutral toned] Shoot him now, shoot him now.
Bugs Bunny: [neutral toned] You keep outta dis, he doesn't hafta shoot you now.
Daffy Duck: [with expression] HA! THAT'TH IT! HOLD IT RIGHT THERE!
[to audience]
Daffy Duck: Pronoun trouble.
[to Bugs]
Daffy Duck: It'th not "He doethn't have to shoot
[pointing to Bugs]
Daffy Duck: *you* now." It'th "He doethn't have to shoot
[pointing to himself]
Daffy Duck: *me* now."
[with anger]
Daffy Duck: Well, *I* thay he *does* have to shoot me now!
[to Elmer]
Daffy Duck: THO SHOOT ME NOW!
[Elmer shoots him]
