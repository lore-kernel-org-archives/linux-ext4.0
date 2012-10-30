From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing device needs stable page writes
Date: Tue, 30 Oct 2012 00:10:22 -0400
Message-ID: <yq1ehkg8us1.fsf@sermon.lab.mkp.net>
References: <20121026101909.GB19617@blackbox.djwong.org>
	<20121027013524.GA19591@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20121027013524.GA19591@blackbox.djwong.org> (Darrick J. Wong's
	message of "Fri, 26 Oct 2012 18:35:24 -0700")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> "Darrick" == Darrick J Wong <darrick.wong@oracle.com> writes:

Darrick> This creates BDI_CAP_STABLE_WRITES, which indicates that a
Darrick> device requires stable page writes.  It also plumbs in a sysfs
Darrick> attribute so that admins can check the device status.

Might be nice to make the sysfs knob tweakable. Also, don't forget to
add a suitable blurb to Documentation/ABI/.

Feel free to add my Acked-by:

-- 
Martin K. Petersen	Oracle Linux Engineering
