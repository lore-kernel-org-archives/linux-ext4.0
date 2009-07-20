From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: default ext3 journal mode - time to poke at this again?
Date: Mon, 20 Jul 2009 15:25:00 -0400
Message-ID: <4A64C48C.8000504@redhat.com>
References: <4A61C60D.5090702@gmail.com> <20090720185731.GA9002@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Stephen C. Tweedie" <sct@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090720185731.GA9002@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 07/20/2009 02:57 PM, Jan Kara wrote:
>    Hi,
>
>    
>> At the linux symposium this week, some of us were wondering when it
>> would be safe to try and default ext3's default journal mode back to
>> sanity given that all (?) distros immediately reverted the default to
>> data writeback mode.
>>      
>    Well, at least SUSE still uses data=ordered,barrier as a default (and
> I personally think this is the right thing to do). Hmm, maybe you've
> meant this and just wrote it otherwise given your paragraph below ;)
>    

Definitely what I meant to post - Fedora and RHEL both use ordered mode 
as a default as well. Not many fs developers are fans of data writeback 
mode as far as I can tell...

>    
>> Failing that, can we at least clean up the config option description to
>> properly give the normal users a non-bogus, technical description of the
>> trade off ?
>>      
>    Yes, I'm all for it. Will you try to write up something or should I?
>
> 									Honza
>    

I posted something (from rwheeler@redhat.com) earlier today and we had a 
discussion about this on the ext4 call. I think that Ted will try to 
update the text that I proposed over the next couple of days.

I think that Chris will be reposting his data guarded mode patches soon 
as well, so we might be able to move forward quickly :-)

ric


