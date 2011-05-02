From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: do not disable ext4 discards on first discard
	failure? [was: Re: dm snapshot: ignore discards issued to the
	snapshot-origin target]
Date: Mon, 02 May 2011 10:20:54 -0400
Message-ID: <yq1bozl420p.fsf@sermon.lab.mkp.net>
References: <20110413224025.GA18589@redhat.com>
	<20110413234854.GA19793@redhat.com>
	<20110426173213.GA19604@redhat.com>
	<20110428001912.GA14659@redhat.com>
	<20110428075355.GA2190@infradead.org>
	<20110428205935.GA24979@redhat.com>
	<alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com>
	<20110429122454.GL32370@agk-dp.fab.redhat.com>
	<alpine.LFD.2.00.1105020857030.3778@dhcp-27-109.brq.redhat.com>
	<20110502081308.GC8642@agk-dp.fab.redhat.com>
	<20110502081925.GA11312@infradead.org>
	<alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        device-mapper development <dm-devel@redhat.com>,
        DarkNovaNick@gmail.com, linux-lvm@redhat.com,
        linux-ext4@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LFD.2.00.1105021217080.3778@dhcp-27-109.brq.redhat.com>
	(Lukas Czerner's message of "Mon, 2 May 2011 12:24:33 +0200 (CEST)")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

>>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:

Lukas> So I gave it a try. First of all the device composed of SSD and
Lukas> spinning disk does export discard_support information properly,
Lukas> however it also advertise discard_zeroes_data which is wrong and
Lukas> possibly dangerous and should be fixed!

I can't reproduce this here. If I mix discard and non-discard devices
things work correctly. discard_zeroes_data also gets cleared if I mix
discard-capable drives where one zeroes and one doesn't.

-- 
Martin K. Petersen	Oracle Linux Engineering
