From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [XFS Punch Hole 1/1] XFS Add Punch Hole Testing to FSX
Date: Tue, 03 May 2011 08:36:34 -0700
Message-ID: <4DC02102.4060101@linux.vnet.ibm.com>
References: <4DBF02FF.608@linux.vnet.ibm.com> <4DC000BB.2090505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4DC000BB.2090505@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 5/3/2011 6:18 AM, Josef Bacik wrote:
> On 05/02/2011 03:16 PM, Allison Henderson wrote:
>> This patch adds punch hole tests to the fsx
>> stress test. The test is performed through
>> the fallocate call by randomly choosing to
>> use the punch hole flag when running the
>> fallocate test. Regions that have
>> been punched out should contain zeros, so
>> the expected file contents buffer is updated
>> to contain zeros when a hole is punched out.
>>
>
> It doesn't look like you have anything to detect if the hole punching
> failed to disable it, how does this behave on say btrfs where we don't
> do hole punching yet? Thanks,
>
> Josef


Hi there,

Oh it looks like I need to add a check for that.  I was so busy using it 
to test ext4 that I forgot to put that in.  Thx!

Allison Henderson
