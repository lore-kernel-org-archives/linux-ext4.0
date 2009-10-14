From: Andy Isaacson <adi@hexapodia.org>
Subject: Re: DMAR regression in 2.6.31 leads to ext4 corruption?
Date: Wed, 14 Oct 2009 10:52:14 -0700
Message-ID: <20091014175214.GD6827@hexapodia.org>
References: <20091009061729.GA31242@hexapodia.org> <20091010000926.GA17547@sequoia.sous-sol.org> <20091010014714.GG30557@hexapodia.org> <1255522166.4523.238.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Wright <chrisw@sous-sol.org>,
	iommu@lists.linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755334AbZJNRww@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1255522166.4523.238.camel@macbook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 14, 2009 at 01:09:26PM +0100, David Woodhouse wrote:
> On Fri, 2009-10-09 at 18:47 -0700, Andy Isaacson wrote:
> > Well, we don't know for sure what happened on the previous boot where
> > the filesystem corruption occurred.  I'm imagining a nightmare scenario
> > where GPU erroneous writes cause DMAR faults and handling them somehow
> > causes AHCI DMA requests to get lost.
> 
> Seems unlikely. The GPU faults happen whenever the GATT changes, because
> it translates _every_ address in the GATT through the IOMMU right there
> and then -- so if parts of the table are uninitialised, they'll cause
> stray write faults. But no writes are actually _happening_.
> 
> > I'm going to go ahead on the theory that the BIOS needs an update.
> 
> I can't really imagine how that would help; how the BIOS would be
> responsible for this. I'm more inclined to blame the drive. It's not an
> SSD, is it?

It's a Fujitsu (now serviced by Toshiba?) MHZ2160BH.  smartctl says:

Device Model:     FUJITSU MHZ2160BH G1
Serial Number:    K60WT8C2HHRS
Firmware Version: 0084000A
User Capacity:    160,041,885,696 bytes
...
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_
FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   100   100   046    Pre-fail  Always       -
       219593
  2 Throughput_Performance  0x0005   100   100   030    Pre-fail  Offline      -
       27721728
  3 Spin_Up_Time            0x0003   100   100   025    Pre-fail  Always       -
       0
  4 Start_Stop_Count        0x0032   099   099   000    Old_age   Always       -
       406
  5 Reallocated_Sector_Ct   0x0033   100   100   024    Pre-fail  Always       -
       8589934592000
  7 Seek_Error_Rate         0x000f   100   100   047    Pre-fail  Always       -
       112
  8 Seek_Time_Performance   0x0005   100   100   019    Pre-fail  Offline      -
       0
  9 Power_On_Hours          0x0032   097   097   000    Old_age   Always       -
       1598
 10 Spin_Retry_Count        0x0013   100   100   020    Pre-fail  Always       -
       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -
       284
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -
       78
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -
       1216
194 Temperature_Celsius     0x0022   100   100   000    Old_age   Always       -
       38 (Lifetime Min/Max 21/46)
195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -
       247
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -
       457965568
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -
       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -
       0
199 UDMA_CRC_Error_Count    0x003e   200   253   000    Old_age   Always       -
       0
200 Multi_Zone_Error_Rate   0x000f   100   100   060    Pre-fail  Always       -
       10448
203 Run_Out_Cancel          0x0002   100   100   000    Old_age   Always       -
       1529011503750
240 Head_Flying_Hours       0x003e   200   200   000    Old_age   Always       -
       0

-andy
