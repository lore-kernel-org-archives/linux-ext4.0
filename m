From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: Multiple Data Stream
Date: Mon, 28 Jul 2008 12:30:23 -0700 (PDT)
Message-ID: <18697577.post@talk.nabble.com>
References: <2d08ef090807270334x4b275c21we69d0dd9fc9a460@mail.gmail.com> <20080727230455.GE7922@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kuber.nabble.com ([216.139.236.158]:52870 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYG1TaY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 15:30:24 -0400
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1KNYQJ-0005Fn-DP
	for linux-ext4@vger.kernel.org; Mon, 28 Jul 2008 12:30:23 -0700
In-Reply-To: <20080727230455.GE7922@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Theodore Tso wrote:
> 
> On Sun, Jul 27, 2008 at 04:04:32PM +0530, Rohit Sharma wrote:
>> Does ext2/ext3 supports multiple data streams.
> 
> No.  The primary use of alternate data streams in Windows XP has been
> Virii, Trojan Horses, and Rootkits.  See this article by Rick Cook,
> "Alternate Data Streams: Threat or Menace:"
> 
> 
>        http://www.informit.com/articles/article.aspx?p=413685
> 
> (Threat or Menace?  Menance or Threat?  Or to quote Bugs Bunny/Daffy
> Duck, "Would you like to shoot me now or wait till you get home?"  :-)
> 
> I've heard stories of System Administrators refusing to upgrade past
> Solaris 8 because of concerns of attackers being able to use the
> alternate data streams feature which Sun unfortunately added in
> Solaris 9 to hide rootkits in ways that traditional scanning tools
> would not be able to detect.
> 
> I've yet to see a coherent argument for why multiple data streams is
> worth it....
> 
> 

Hey Ted,
I am a newbie into these filesystems but I can see the positive sides of
these Alternate Data Streams or multiple data streams too, needless to
mention those.
 
If you look a bit more deeper into it, in my perspective and the kind of
implementation I look forward to, here is what I have.

Access to the multiple data stream can be done through a file descriptor.
Applications can open the multiple data stream to get a file descriptor and
can do read(), write(), mmap().. using the file descriptor. These system
calls would work as if it is been operated on a regular file. 
The multiple data streams of a file will be stored in a hidden named data
stream directory inode associated with the file. The hidden directory inode
for the file can be accessed only through the multiple data stream API.

Now, as the multiple data streams has their own associated inodes, we could
store the access permission as well as the owner/group information in the
multiple data stream inode. This way the access control for the multiple
data stream can be controlled by the permissions stored in the multiple data
stream inode. 
       We could have a model where we use the permissions on the parent file
to be used to check the accessibility of the alternate data stream. It would
also make great sense to me, if we just add a fall back to the kernel to
decide whether a user with particular credentials, should be allowed to
access/make changes to these multiple data streams that are associated with
the file.

To add more to it, any regular file can be created in a regular way but
whatever mechanism is used to create these multiple data streams associated
with the regular file will surely undergo a permission check by the
underlying OS or the filesystem.

Thanks & Regards,
SandeepKsinha.



> 
> 						- Ted
> 
> 
> Bugs Bunny: Would you like to shoot me now or wait 'til you get home?
> Daffy Duck: Shoot him now! Shoot him now!
> Bugs Bunny: You keep outta this! He doesn't have to shoot you now!
> Daffy Duck: He does SO have to shoot me now!
> [to Elmer]
> Daffy Duck: I demand that you shoot me now!
> [Elmer raises his gun. As Daffy sticks his tongue out at Bugs, he is shot] 
> 
> 
> Daffy Duck: Let'th run through that again.
> Bugs Bunny: Okay.
> [neutral toned]
> Bugs Bunny: Wouldja like to shoot me now or wait till ya get home.
> Daffy Duck: [neutral toned] Shoot him now, shoot him now.
> Bugs Bunny: [neutral toned] You keep outta dis, he doesn't hafta shoot you
> now.
> Daffy Duck: [with expression] HA! THAT'TH IT! HOLD IT RIGHT THERE!
> [to audience]
> Daffy Duck: Pronoun trouble.
> [to Bugs]
> Daffy Duck: It'th not "He doethn't have to shoot
> [pointing to Bugs]
> Daffy Duck: *you* now." It'th "He doethn't have to shoot
> [pointing to himself]
> Daffy Duck: *me* now."
> [with anger]
> Daffy Duck: Well, *I* thay he *does* have to shoot me now!
> [to Elmer]
> Daffy Duck: THO SHOOT ME NOW!
> [Elmer shoots him]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
View this message in context: http://www.nabble.com/Multiple-Data-Stream-tp18675139p18697577.html
Sent from the linux-ext4 mailing list archive at Nabble.com.

