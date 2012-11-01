From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Wed, 31 Oct 2012 23:25:30 -0700
Message-ID: <509215DA.6060609@panasas.com>
References: <20121027013524.GA19591@blackbox.djwong.org> <yq1ehkg8us1.fsf@sermon.lab.mkp.net> <20121030154844.1898f068@notabene.brown> <yq1a9v4884i.fsf@sermon.lab.mkp.net> <20121030201424.GD19559@blackbox.djwong.org> <20121031091441.5fc6b412@notabene.brown> <20121031085604.GC19591@blackbox.djwong.org> <20121031115614.GC18424@quack.suse.cz> <20121031193652.GF19591@blackbox.djwong.org> <5091B075.7030608@panasas.com> <20121101055109.GD19576@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, NeilBrown <neilb@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:55044 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab2KAGZj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Nov 2012 02:25:39 -0400
In-Reply-To: <20121101055109.GD19576@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/31/2012 10:51 PM, Darrick J. Wong wrote:
> 
> Of course, all that goes out the door with iscsi since it doesn't necessarily
> care about DIF/DIX but wants stable pages anyway.  It'd be useful to be able to
> play around with iscsi too.  Could you point me to where in the iscsi code it
> does the copy-and-checksum behavior?
> 

I'll send you an untested proof of concept patch tomorrow. So at least you can
see where the code is. But no guaranty that it actually works.

You will need to dig into iscsi docs to enable it in config files, look for
data_digest= or something like that.

header digest is when only the headers are check-summed and data-digest is when
all the data is check-summed.

> --D
> 

Cheers
Boaz
