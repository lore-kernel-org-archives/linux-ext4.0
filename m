From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Filesystem recovery - e2fsck seems to have caused my filesystem
 to get wiped
Date: Wed, 30 Oct 2013 11:14:08 -0500
Message-ID: <52713050.80404@redhat.com>
References: <1829785915.95.1383138487671.JavaMail.root@reganw.com> <5271297B.7040101@redhat.com> <52712D04.1030104@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Bernd Schubert <bernd.schubert@fastmail.fm>,
	Regan Wallace <regan@reganw.com>, linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab3J3QOP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Oct 2013 12:14:15 -0400
In-Reply-To: <52712D04.1030104@fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/30/13 11:00 AM, Bernd Schubert wrote:

> Why not just unset the journal feature bit using debugfs?
> 
> debugfs -w -R "features ^has_journal"  sda1.img


Because I forgot about that option and/or thought it didn't
allow it on a dirty fs.  ;)

Much better, thanks.  :)

-Eric
