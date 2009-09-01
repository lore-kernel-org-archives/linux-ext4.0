From: "NeilBrown" <neilb@suse.de>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
Date: Tue, 1 Sep 2009 18:36:22 +1000 (EST)
Message-ID: <4a2c5faeb04cab59af9ba6ab512c9916.squirrel@neil.brown.name>
References: <20090901005629.3932.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: david@lang.hm, pavel@ucw.cz, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@horizon.com
To: "George Spelvin" <linux@horizon.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090901005629.3932.qmail@science.horizon.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, September 1, 2009 10:56 am, George Spelvin wrote:
> The fact that the ZFS decelopers observed drives writing the data to the
> wrong location emphasizes the importance of keeping the checksum with
> the pointer.  An embedded checksum, no matter how good, can't tell you if
> the data is stale; you need a way to distinguish versions in the pointer.

I would disagree with that.
If the embedded checksum is a function of both the data and the address
of the data (in whatever address space seems most appropriate) then it can
still verify that the data found with the checksum is the data that was
expected.
And storing the checksum with the data (where it is practical) means
index blocks can be more dense so on average fewer accesses to storage
are needed.

NeilBrown

