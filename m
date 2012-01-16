From: Asdo <asdo@shiftmail.org>
Subject: Re: Filesystem freeze vs blockdevice snapshot
Date: Mon, 16 Jan 2012 18:03:07 +0100
Message-ID: <4F14584B.9080008@shiftmail.org>
References: <4F104E2D.3080105@shiftmail.org>
 <CAOQ4uxhTueTHi3UP3AdQo1x1+ONx4Fn8t1F_s9PLZu6arhzN7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blade3.isti.cnr.it ([194.119.192.19]:1937 "EHLO
	blade3.isti.cnr.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab2APRDD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jan 2012 12:03:03 -0500
Received: from [192.168.1.115] ([155.253.6.254])
 by mx.isti.cnr.it (PMDF V6.6 #31988)
 with ESMTPSA id <01OAV4DICRSUGPTS59@mx.isti.cnr.it> for
 linux-ext4@vger.kernel.org; Mon, 16 Jan 2012 18:02:49 +0100 (MET)
In-reply-to: <CAOQ4uxhTueTHi3UP3AdQo1x1+ONx4Fn8t1F_s9PLZu6arhzN7Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[sorry for double posting : had forgot to remove html]

Thanks but it's still not clear to me.
What do you mean with "clean fs"? is that in any way different from an 
image after a sudden power loss?
Secondarily, how can LVM know what filesystem is underneath and call the 
proper freeze? That's a bare block device, there might not even be a 
filesystem under LVM; or it might be exported via iSCSI to an XYZ 
operating system using the Xyzfs filesystem which Linux knows nothing 
about...
Thank you

On 01/14/12 19:33, Amir Goldstein wrote:
> LVM2 already does the fs freeze for you before taking the snapshot.
> it's the only way to get a block device snapshot of a "clean" fs.
> hope that answers your question.
>
> On Fri, Jan 13, 2012 at 5:30 PM, Asdo <asdo@shiftmail.org 
> <mailto:asdo@shiftmail.org>> wrote:
>
>     Hello all,
>     please excuse the silly question...
>
>     What is the benefit of performing an ext4 fs freeze before taking
>     a snapshot of the underlying block device with LVM2 ?
>
>     Is the freeze step useful or I can go with the snapshot directly?
>
>     And/or is there another use case for the freeze?
>
>     Thank you
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-ext4" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>


