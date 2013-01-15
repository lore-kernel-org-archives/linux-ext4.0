From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 4/5] mke2fs: teach mke2fs to understand -b 4k and -C 256M
Date: Tue, 15 Jan 2013 09:13:24 -0600
Message-ID: <50F57214.3050101@redhat.com>
References: <20130114211014.GA22642@thunk.org> <1358210232-30578-1-git-send-email-tytso@mit.edu> <1358210232-30578-4-git-send-email-tytso@mit.edu> <50F571B3.8040500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	gnehzuil.liu@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896Ab3AOPNk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 10:13:40 -0500
In-Reply-To: <50F571B3.8040500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/15/13 9:11 AM, Eric Sandeen wrote:
> On 1/14/13 6:37 PM, Theodore Ts'o wrote:
>> The -b and -C options now use parse_num_blocks2() insteda of strtol,
>> so that users can specify -C 256M instead of the much less convenient
>> -C 268435456.
> 
> Hm and -C isn't in the manpage at all.
> 
> Seems like the mke2fs manpage needs an update for bigalloc?

I'm sorry, I see that patch has already been sent.  I'll catch
up with my email, now.  :(

-Eric

> -Eric
> 
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>> ---
>>  misc/mke2fs.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
>> index 5cb49b3..c16ab33 100644
>> --- a/misc/mke2fs.c
>> +++ b/misc/mke2fs.c
>> @@ -1324,10 +1324,10 @@ profile_error:
>>  		    "b:cg:i:jl:m:no:qr:s:t:vC:DE:FG:I:J:KL:M:N:O:R:ST:U:V")) != EOF) {
>>  		switch (c) {
>>  		case 'b':
>> -			blocksize = strtol(optarg, &tmp, 0);
>> +			blocksize = parse_num_blocks2(optarg, -1);
>>  			b = (blocksize > 0) ? blocksize : -blocksize;
>>  			if (b < EXT2_MIN_BLOCK_SIZE ||
>> -			    b > EXT2_MAX_BLOCK_SIZE || *tmp) {
>> +			    b > EXT2_MAX_BLOCK_SIZE) {
>>  				com_err(program_name, 0,
>>  					_("invalid block size - %s"), optarg);
>>  				exit(1);
>> @@ -1345,9 +1345,9 @@ profile_error:
>>  			cflag++;
>>  			break;
>>  		case 'C':
>> -			cluster_size = strtoul(optarg, &tmp, 0);
>> +			cluster_size = parse_num_blocks2(optarg, -1);
>>  			if (cluster_size <= EXT2_MIN_CLUSTER_SIZE ||
>> -			    cluster_size > EXT2_MAX_CLUSTER_SIZE || *tmp) {
>> +			    cluster_size > EXT2_MAX_CLUSTER_SIZE) {
>>  				com_err(program_name, 0,
>>  					_("invalid cluster size - %s"),
>>  					optarg);
>>
> 

