From: Tao Ma <tm@tao.ma>
Subject: Re: DIO process stuck apparently due to dioread_nolock (3.0)
Date: Tue, 16 Aug 2011 12:15:53 +0800
Message-ID: <4E49EEF9.7070204@tao.ma>
References: <4E456436.8070107@msgid.tls.msk.ru>	<1313251371-3672-1-git-send-email-tm@tao.ma>	<4E4836A8.3080709@msgid.tls.msk.ru>	<4E48390E.9050102@msgid.tls.msk.ru>	<4E488625.609@tao.ma>	<4E48D231.5060807@msgid.tls.msk.ru>	<4E48DF31.4050603@msgid.tls.msk.ru> <CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com, Jan Kara <jack@suse.cz>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:34810 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750902Ab1HPEP7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Aug 2011 00:15:59 -0400
In-Reply-To: <CAFgt=MAfbU_muEzmxx-8CK8w7=nGR5dUZSgBQ1dN6XkyrTbO9g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jiaying,
On 08/16/2011 07:53 AM, Jiaying Zhang wrote:
> Hi Michael,
> 
> On Mon, Aug 15, 2011 at 1:56 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>> 15.08.2011 12:00, Michael Tokarev wrote:
>> [....]
>>
>> So, it looks like this (starting with cold cache):
>>
>> 1. rename the redologs and copy them over - this will
>>   make a hot copy of redologs
>> 2. startup oracle - it will complain that the redologs aren't
>>   redologs, the header is corrupt
>> 3. shut down oracle, start it up again - it will succeed.
>>
>> If between 1 and 2 you'll issue sync(1) everything will work.
>> When shutting down, oracle calls fsync(), so that's like
>> sync(1) again.
>>
>> If there will be some time between 1. and 2., everything
>> will work too.
>> 
>> Without dioread_nolock I can't trigger the problem no matter
>> how I tried.
>>
>>
>> A smaller test case.  I used redo1.odf file (one of the
>> redologs) as a test file, any will work.
>>
>>  $ cp -p redo1.odf temp
>>  $ dd if=temp of=foo iflag=direct count=20
> Isn't this the expected behavior here? When doing
> 'cp -p redo1.odf temp', data is copied to temp through
> buffer write, but there is no guarantee when data will be
> actually written to disk. Then with 'dd if=temp of=foo
> iflag=direct count=20', data is read directly from disk.
> Very likely, the written data hasn't been flushed to disk
> yet so ext4 returns zero in this case.
Sorry, but it doesn't sound correct to me.
Say we use a buffer write to a file and then use direct i/o read, what
we expect(or at least Michael expect) is that we use read the updated
data, not the stale one. I thought of a tiny race window in ext4 here,
but need to do some test to verify and then fix it.

Thanks
Tao
