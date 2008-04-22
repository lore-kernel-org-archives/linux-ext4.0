From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem
 checker)
Date: Tue, 22 Apr 2008 12:02:55 -0500
Message-ID: <480E1A3F.9030103@redhat.com>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com>	 <20080419012952.GE25797@mit.edu>	 <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com>	 <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com> <804dabb00804220954s67d56cacj89098d88697565aa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Peter Teoh <htmldeveloper@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <804dabb00804220954s67d56cacj89098d88697565aa@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Peter Teoh wrote:
> On Sun, Apr 20, 2008 at 3:07 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> Theodore Tso wrote:
>>  > On Sat, Apr 19, 2008 at 01:44:51PM +0400, Alexey Zaytsev wrote:
>>  >> If it is a block containing a metadata object fsck has already read,
>>  >> than we already know what kind of object it is (there must be a way
>>  >> to quickly find all cached objects derived from a given block), and
>>  >> can update the cached version. And if fsck has not yet read the
>>  >> block, it can just be ignored, no matter what kind of data it
>>  >> contains. If it contains metadata and fsck is intrested in it, it
>>  >> will read it sooner or later anyway. If it contains file data, why
>>  >> should fsck even care?
>>
>>  It seems to me that what the proposed project really does, in essence,
>>  is a read-only check of a filesystem snapshot.  It's just that the
>>  snapshot is proposed to be constructed in a complex and non-generic (and
>>  maybe impossible) way.
>>
>>  If you really just want to verify a snapshot of the fs at a point in
>>  time, surely there are simpler ways.  If the device is on lvm, there's
>>  already a script floating around to do it in automated fasion.  (I'd
>>  pondered the idea of introducing META_WRITE (to go with META_READ) and
>>  maybe lvm could do a "metadata-only" snapshot to be lighter weight?)
>>
> 
> Can I know where is this script?   Or if u cannot locate it, does it
> have any resemblance to all the stuff mentioned below?.

Google for "lvcheck" and find it buried in a thread "forced fsck
(again?)" on the ext3-users list - I'm not sure if it has an upstream
home anywhere yet...

-Eric
