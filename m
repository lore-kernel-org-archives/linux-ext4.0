From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Fri, 04 Feb 2011 12:03:16 -0500
Message-ID: <4D4C3154.3020502@gmail.com>
References: <20110203144011.GA28409@quack.suse.cz> <4D4AC4E2.701@redhat.com> <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com> <20110204131739.GC4104@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Michael Rubin <mrubin@google.com>,
	Eric Sandeen <sandeen@redhat.com>,
	lsf-pc@lists.linuxfoundation.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110204131739.GC4104@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 02/04/2011 08:17 AM, Jan Kara wrote:
> On Thu 03-02-11 11:32:01, Michael Rubin wrote:
>> On Thu, Feb 3, 2011 at 7:08 AM, Eric Sandeen<sandeen@redhat.com>  wrote:
>>> If we can have a real plan for moving in this direction though, I'd
>>> support it.  I'm just not sure how we get enough real testing under
>>> our belts to be comfortable with dropping ext[23], especially as
>>> most distros now default to ext4 anyway.
>> Eric what sort of testing are you looking for?
> I believe Ted wrote a good summary of what combinations of options would
> need to be tested on a regular basis to get at least some confidence that
> the switch could work.
>
>> I admit I like having ext2 around for comparisons in bug situations.
>> It really helps to isolate the problem area. How painful is the
>> upkeep?
> Well, for me it's a couple of hours per week on average I'd say. Plus
> there is some work other people do when changing some VFS/MM interfaces
> influencing all the filesystems.
>
> The time I spend is enough to keep ext3 in a good shape I believe but I
> have a feeling that ext2 is slowly bitrotting. Sometime when I look at
> ext2 code I see stuff we simply do differently these days and that's just
> a step away from the code getting broken... It would not be too much work
> to clean things up and maintain but it's a work with no clear gain (if you
> do the thankless job of maintaining old code, you should at least have
> users who appreciate that ;) so naturally no one does it.
>
> 								Honza

I would definitely be interesting in figuring out if and when we can drop one or 
both of ext2 and ext3. The number of actively supported file systems to test for 
correctness and performance is getting to be a challenge.

Great topic, might require beer though to be done right :)

ric

