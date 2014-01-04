From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: ext4 goes into read only mode on using discard with htree_dirblock_to_tree
 ... bad entry in directory
Date: Sat, 04 Jan 2014 15:35:31 +0100
Message-ID: <52C81C33.2030300@fastmail.fm>
References: <CAHy4Ox1fjTbOxiTqcqyhihYkRs2po7Xs4EWxsFVP+HHyJWpSfg@mail.gmail.com> <20140102185507.GD10870@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Ritesh Khadgaray <khadgaray@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49632 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbaADOfd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Jan 2014 09:35:33 -0500
Received: from compute5.internal (compute5.nyi.mail.srv.osa [10.202.2.45])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 919C920BD5
	for <linux-ext4@vger.kernel.org>; Sat,  4 Jan 2014 09:35:32 -0500 (EST)
In-Reply-To: <20140102185507.GD10870@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 01/02/2014 07:55 PM, Theodore Ts'o wrote:
> On Thu, Jan 02, 2014 at 10:49:56AM +0530, Ritesh Khadgaray wrote:

> 
> However, in your case, if discard commands are causing on-disk
> corruption, I'm not sure I can even in good conscience recommend using
> fstrim.
> 
>> Device Model: Crucial_CT960M500SSD1
>> Serial Number: 1335094BE7CA
>> LU WWN Device Id: 5 00a075 1094be7ca
>> Firmware Version: MU03
> 

If this is not a production system you can try to switch to another 
provisioning mode. I.e. Intel510 drives cause data corruption with 
write-same-10, but unmap works fine.

cat /sys/class/scsi_disk/H\:C\:I\:L/provisioning_mode 

and

echo -n {writesame_16,unmap} > /sys/class/scsi_disk/H\:C\:I\:L/provisioning_mode


(lsscsi can provide the H:C:I:L tuplet)



Cheers,
Bernd
