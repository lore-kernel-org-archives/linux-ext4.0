From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing device needs stable page writes
Date: Tue, 30 Oct 2012 08:19:41 -0400
Message-ID: <yq1a9v4884i.fsf@sermon.lab.mkp.net>
References: <20121026101909.GB19617@blackbox.djwong.org>
	<20121027013524.GA19591@blackbox.djwong.org>
	<yq1ehkg8us1.fsf@sermon.lab.mkp.net>
	<20121030154844.1898f068@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: NeilBrown <neilb@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20121030154844.1898f068@notabene.brown> (NeilBrown's message of
	"Tue, 30 Oct 2012 15:48:44 +1100")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:

Neil,

>> Might be nice to make the sysfs knob tweakable. Also, don't forget to
>> add a suitable blurb to Documentation/ABI/.

Neil>  It isn't at all clear to me that having the sysfs knob
Neil>  'tweakable' is a good idea.  From the md/raid5 perspective, I
Neil>  would want to know for certain whether the pages in a give bio
Neil>  are guaranteed not to change, or if they might.  I could set the
Neil>  BDI_CAP_STABLE_WRITES and believe they will never change, or test
Neil>  the BDI_CAP_STABLE_WRITES and let that tell me if they might
Neil>  change or not.  But if the bit can be changed at any moment, then
Neil>  it can never be trusted and so becomes worthless to me.

I was mostly interested in being able to turn it on for devices that
haven't explicitly done so. I agree that turning it off can be
problematic.

-- 
Martin K. Petersen	Oracle Linux Engineering
