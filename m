From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] vfs: allow custom EOF in generic_file_llseek code
Date: Fri, 27 Apr 2012 18:01:38 -0500
Message-ID: <4F9B2552.9010803@sandeen.net>
References: <4F9AC770.8080004@redhat.com> <4F9B2219.6090302@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4F9B2219.6090302@itwm.fraunhofer.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 4/27/12 5:47 PM, Bernd Schubert wrote:
> On 04/27/2012 06:21 PM, Eric Sandeen wrote:

...

>> +generic_file_llseek_size_eof(struct file *file, loff_t offset, int origin,
>> +		loff_t maxsize, loff_t eof)
>>  {
>>  	struct inode *inode = file->f_mapping->host;
>>  
>>  	switch (origin) {
>>  	case SEEK_END:
>> -		offset += i_size_read(inode);
>> +		offset += eof;
>>  		break;
> 
> Here is the only glitch I can see. As Andreas already said before, it
> might overflow here. Do we need do care about that? As you already said,
> SEEK_END is unlikely to be ever called for directories. But then we also
> cannot keep user space from doing weird calls...

It can happen already today, for a sufficiently large file offset.

# ls -l reallybigfile 
-rw-r--r--. 1 root root 9223372036854775807 Apr 27 18:02 reallybigfile

(that's 2^63 - 1)

so overflow protection may be warranted in here, but I think it's a separate problem.

...

>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 8de6755..a6ae7a4 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -2402,6 +2402,8 @@ extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
>>  extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
>>  extern loff_t generic_file_llseek_size(struct file *file, loff_t offset,
>>  		int origin, loff_t maxsize);
>> +extern loff_t generic_file_llseek_size_eof(struct file *file, loff_t offset,
>> +		int origin, loff_t maxsize, loff_t eof);
>>  extern int generic_file_open(struct inode * inode, struct file * filp);
>>  extern int nonseekable_open(struct inode * inode, struct file * filp);
> 
> Another question, wouldn't it be better to entirely move
> generic_file_llseek_size() and generic_file_llseek() into fs.h to make
> sure it gets inlined?

Hm, perhaps.  It wasn't done for generic_file_llseek_size() so I just followed
that example, for now.

-Eric
