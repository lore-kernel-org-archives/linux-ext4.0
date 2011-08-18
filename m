From: Chris Lee <cslee-list@cybericom.co.uk>
Subject: Re: [Bug 15875] Add an option to disable file/directory permissions
 for ACL'ed file systems
Date: Thu, 18 Aug 2011 16:03:34 +0100
Message-ID: <4E4D29C6.7000908@cybericom.co.uk>
References: <bug-15875-13602@https.bugzilla.kernel.org/> <201011041548.oA4FmPl4005005@demeter2.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:5633
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319Ab1HRPPM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Aug 2011 11:15:12 -0400
In-Reply-To: <201011041548.oA4FmPl4005005@demeter2.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 04/11/10 15:48, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=15875
>
>
> Theodore Tso<tytso@mit.edu>  changed:
>
>             What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                   CC|                            |tytso@mit.edu
>
>
>
>
> --- Comment #11 from Theodore Tso<tytso@mit.edu>   2010-11-04 15:48:22 ---
> So this bug report is highly confused.  Reading the original request, I think
> what the original poster was requesting was actually a way of disabling all
> access controls, and ACL's (meaning Access Control Lists) has nothing to do
> with this at all.
>
> Ideally I think this should be a VFS-level mount option (like read-only,
> noatime) so that it's not an ext4 specific option.  But if we can't get
> consensus across other file system developer teams, doing it as an ext4
> specific mount option is a possibility.
>
I know this is an old post I am dragging up but I have not seen any further 
discussion and I would like to see the a solution for the following use case:
I grab the SD card out of a friends camera which stores images on an extX file 
system and shove it into my PC. My PC makes all the files owned by me so that I 
can access them, just like today with FAT based sd cards.
If this is done at the VFS level then how is my PC going to know that the file 
system on the SD card has permissions that should be ignored?
Or should things like cameras all just write files with owner id 0 and 
permissions set to 777?
My issue with this is when I change the permissions by using some broken 
software and then put it back in the camera will it be able to store the images 
in a permission modified directory? or will the owner of the camera have 
problems later on when they try to get the content off the card?

It would be nice if the file system had a "data in this file system is for 
anyone who can get their hands on it" mode that was well defined so that device 
manufacturers would feel safer using it for mass end user use.

Regards,
Chris.
