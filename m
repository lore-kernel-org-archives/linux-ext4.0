From: Mark Casey <markc@unifiedgroup.com>
Subject: Re: e2fsck repeatedly asks to clear the same entry?
Date: Sun, 25 Nov 2012 21:52:02 -0600
Message-ID: <50B2E762.5040906@unifiedgroup.com>
References: <k8of5a$sjb$1@ger.gmane.org> <07FA29B6-B150-4A93-B6FF-3072DF31B577@gmail.com> <50B068E3.4090100@unifiedgroup.com> <7BE44E5B-807D-4C20-8D49-88D0394147FD@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44326 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab2KZDwP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Nov 2012 22:52:15 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Tcpk7-000142-MT
	for linux-ext4@vger.kernel.org; Mon, 26 Nov 2012 04:52:23 +0100
Received: from cpe-76-183-161-185.tx.res.rr.com ([76.183.161.185])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 04:52:23 +0100
Received: from markc by cpe-76-183-161-185.tx.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2012 04:52:23 +0100
In-Reply-To: <7BE44E5B-807D-4C20-8D49-88D0394147FD@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/24/2012 1:17 PM, Andreas Dilger wrote:
>
> So this is the problematic entry. The directory entry looks ok, though it doesn't have the same name as e2fsck reports. It claims the entry is "A5 11-3", which is a bit bizarre.

My fault. I was initially inconsistent in deciding what parts of our 
real tree I wanted online. So there is nothing named "A5 11-3". Should 
not be an issue again; sorry to add complication.

>
> ...
>
> Yes, though if this directory is accessed it might turn the filesystem read-only.

Yep, it does.

>
>> These files are older so I wouldn't mind setting the permissions so that no one can get to them for a bit. What would I need to do to get a test case going?
>
> Just mark the parent directory inaccessible:
>
> # chmod 000 "/share/path/09/Brett/Pines/Flynt's Side Drive - Complete Archive Copy/SA Version Pines/Chris Pics 11-2-10/Group 5 11-3"
>

No problem. Once I've got that done I'll see what I can do with e2image. 
I really appreciate the input so I'd like to do whatever I can if you 
still think it might lead to some sort of bugfix. So far the only 
changes made were to restore the other files that the post-resize fsck 
had to remove/free. Final total was a couple gigs across 7 dirs.

I've looked for any stat differences between the current file tree and 
the one from the backup just before the resize. The only issue found is 
that there appear to be ~200 directories that were not removed by fsck 
but appear to have had their modtimes reset by it instead. The actual 
files contained were untouched. If that is also no big concern then I 
think later tonight, after/if I can get an e2image done, I'll just 
restore their modtimes from the backup to make things pretty again.

Thank you,
Mark

