From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] ext4: use swap macro in mext_page_double_lock
Date: Sun, 22 Jul 2018 18:30:53 -0500
Message-ID: <fc152714-1784-bb0c-5340-db50e63e2044@embeddedor.com>
References: <20180709131600.GA9138@embeddedor.com>
 <20180722221911.GC3358@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180722221911.GC3358@thunk.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Theodore,

On 07/22/2018 05:19 PM, Theodore Y. Ts'o wrote:
> On Mon, Jul 09, 2018 at 08:16:00AM -0500, Gustavo A. R. Silva wrote:
>> Make use of the swap macro and remove unnecessary variable *tmp*.
>> This makes the code easier to read and maintain. Also, reduces the
>> stack usage.
>>
>> This code was detected with the help of Coccinelle.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> 
> It doesn't actually reduce stack usage.  Look at the definition of
> swap() in include/linux/kernel.h:
> 
> #define swap(a, b) \
> 	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
> 
> It removes the variable "tmp", and replace it with "__tmp".
> 
> It slightly reduces the number of lines of code, so it slightly makes
> the code easier to maintainer.  But I think you are really
> over-promising how much this commit helps.
> 
I'll remove that part from the changelog and send it again.

Thanks
--
Gustavo
